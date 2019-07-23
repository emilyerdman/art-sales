class WorksController < ApplicationController
  before_action :set_work, only: [:show, :update]
  NUM_WORKS = 10
  ADMIN_NUM_WORKS = 50
  SORT_BY = 0
  NONCORP_VALUE_CEIL = 400.0

  # SORT ORDERS
  # inventory number asc = 0
  # inventory number desc = 1
  # title desc = 2
  # title asc = 3
  # artist desc = 4
  # artist asc = 5
  # retail value desc = 6
  # retail value asc = 7
  
  def all
    if current_user    
      @page = (params[:page] || 1).to_i
      @numworks = (params[:numworks] || NUM_WORKS).to_i
      @category_combo = (params[:category_combo] || "AND")
      @sort_by = (params[:sort_by] || 0)

      #admin can see all works
      @works = Work.all

      #posters users can only see posters
      posters = @works.art_type_filter('POSTER').availability_filter('= 0')
      #non corporate can see posters + non corp coll available
      non_corporate = @works.art_type_filter('FINE ART').corp_coll_filter(false).eag_availability_filter(true)
      #corporate can see posters + non corp coll available + corp coll available
      corporate = @works.art_type_filter('FINE ART').eag_availability_filter(true)

      # poster user can only see posters (but none are EAG confirmed), so they have no availability constraints
      if current_user.posters?
        @works = posters
      end
      
      # non corporate can't see any corporate or any non-available fine art
      if current_user.non_corporate?
        @works = posters.or(non_corporate)
        retail_below = @works.retail_value_filter("< %d" % NONCORP_VALUE_CEIL)
        retail_none = @works.retail_value_filter("is NULL")
        @works = retail_below.or(retail_none)
      end

      # corporate can't see any non-available fine art
      if current_user.corporate?
        @works = posters.or(non_corporate.or(corporate))
      end


      if params[:art_type].present? && !@current_user.posters?
        @works = @works.art_type_filter(params[:art_type])
      end

      # FIX THIS FILTER
      # only the admin can look at the non-available works
      if params[:availability].present? && current_user.admin?
        if params[:availability].eql?('1')
          posters_available = @works.art_type_filter('POSTER').availability_filter('= 0')
          eag_confirmed = @works.eag_availability_filter(true)
          @works = posters_available.or(eag_confirmed)
        else
          has_current_owner = @works.art_type_filter('POSTER').availability_filter('> 0')
          non_eag_confirmed = @works.art_type_filter('FINE ART').eag_availability_filter(false)
          @works = has_current_owner.or(non_eag_confirmed)
        end
      end

      if params[:framed].present?
        @works = @works.framed_filter(ActiveModel::Type::Boolean.new.cast(params[:framed]))
      end

      # filter by corporate collection/noncorporate if available to them
      if params[:collection].present?
        if params[:collection].eql?('CORP')
          @works = @works.corp_coll_filter(true)
        elsif params[:collection].eql?('NONCORP')
          @works = @works.corp_coll_filter(false)
        end
      end

      # search causes other filters to reset
      if params[:search].present?
        stripped_param = params[:search].strip.downcase
        works_filtered = @works.search_filter(stripped_param)
        contacts_filtered = @works.where(artist_id: Artist.artist_filter(stripped_param))
        @works = works_filtered.or(contacts_filtered)
      end

      if params[:category].present?
        combo = params[:category_combo]
        if combo.eql?("OR")
          all_filtered = Work.none
        else
          all_filtered = Work.all
        end
        params[:category].each do |category|
          filtered = @works.category_filter(category)
          puts filtered.count
          if combo.eql?("OR")
            all_filtered = filtered.or(all_filtered)
          else
            all_filtered = filtered.merge(all_filtered)
          end
          puts all_filtered.count
         end
        @works = all_filtered
      end

      @works = sort_works(params[:sort_by].to_i, @works)


      @total_works = @works.size
      @works = @works.offset(@numworks * (@page - 1)).limit(@numworks)
      @pager = pager(@page, @total_works, @numworks)
    end
  end

    
  def show
    @artist = Artist.find(@work.artist_id)
    @contact = Contact.find_by_id(@work.contact_id)
  end

  def admin_index
    @numworks = ADMIN_NUM_WORKS
    @page = (params[:page] || 1).to_i
    @works = sort_works((params[:sort_by].to_i || 0), Work.all.offset(@numworks * (@page -1)))
    @total_works = @works.size
    @works = @works.limit(@numworks)
  end

  def update
    if current_user.admin? && @work.update(work_params)
      redirect_to works_admin_path
    else
      format.html { redirect_to @user, notice: 'User was successfully updated.' }
    end
  end


      # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user == @user && @user.update(user_params)
      format.html { redirect_to @user, notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }
    else
      format.html { render :edit }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_params
      params.require(:work).permit(:eag_confirmed, :location)
    end

    def sort_works(sort_type, works)
      if sort_type == 0
        works = works.order(inventory_number: :asc)
      elsif sort_type == 1
        works = works.order(inventory_number: :desc) 
      elsif sort_type == 2
        works = works.order(title: :desc)
      elsif sort_type == 3
        works = works.order(title: :asc)
      elsif sort_type == 4
        works = works.order(retail_value: :desc).where.not(retail_value: nil)
      elsif sort_type == 5
        works = works.order(retail_value: :asc).where.not(retail_value: nil)
      end
    return works
  end

  def pager(page, total_works, numworks)
    first_array = []
    second_array = []
    third_array = []
    num_pages = (total_works/numworks.to_f).ceil
    # 1-3 .. X-1 X X+1 .. total_works : 10 < X < total_works - 2 && total_works > 10
    # 1-9 .. total_works : X <= 10 && total_works > 10
    # 1-5 .. X X+1 X+2 X+3 total_works : X >= total_works - 4 && total_works > 10
    # 1-total_works : <= 10 && total_works <= 10
    # 1-X ..
    if num_pages > 10
      if page < num_pages - 2 && page > 4
        first_array = Array(1..3)
        second_array = [page-1, page, page + 1]
        third_array = [num_pages]
      else
          first_array = Array(1..5)
          third_array = Array((num_pages-4)..num_pages)
      end
    else
      # simple paging
      first_array = Array(1..num_pages)
    end
    return [first_array, second_array, third_array]
  end

end
