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
    if current_user && current_user.approved    
      @category_combo = (params[:category_combo] || "AND")
      @sort_by = (params[:sort_by] || 0)
      @works = Work.none
      @page = (params[:page] || 1).to_i
      @numworks = (params[:numworks] || NUM_WORKS).to_i      

      @works = get_user_category_works()

      if params[:art_type].present? && !current_user.posters?
        puts 'filtering art type'
        # posters user can't filter by art type
        @works = Work.filterByArtType(@works, params[:art_type])
      end

      # only the admin can look at the non-available works
      if params[:availability].present? && current_user.admin?
        puts 'filtering availability'
        @works = Work.filterByAvailability(@works, params[:availability])
      end

      if params[:framed].present? && !params[:framed].eql?('ALL')
        puts 'filtering framed'
        @works = Work.filterByFramed(@works, params[:framed])
      end

      # filter by corporate collection/noncorporate if admin or corp collection user
      if params[:collection].present? && (current_user.admin? || current_user.corporate?) && !params[:collection].eql?('ALL')
        puts 'filtering collection'
        @works = Work.filterByCollection(@works, params[:collection])
      end

      # search causes other filters to reset
      if params[:search].present? 
        puts 'filtering search'
        @works = Work.searchWorks(@works, params[:search])
      end

      if params[:category].present?
        puts 'filtering category'
        @works = Work.filterByCategory(@works, params[:category], params[:combo])
      end

      if params[:unique].present? && params[:unique].eql?('1')
        puts 'filtering unique'
        @works = Work.filterUnique(@works)
      end

      # sort according to the sort_by param (always present)
      @works = Work.sortWorks(@works, params[:sort_by].to_i)
      @total_works = @works.size
      @works = @works.offset(@numworks * (@page - 1)).limit(@numworks)
      @pager = pager(@page, @total_works, @numworks)
    end
  end

    
  def show
    user_works = get_user_category_works()
    @artist = Artist.find(@work.artist_id)
    @works = user_works.find_by_artist_id(@artist.id)
  end

  def admin_index
    @numworks = ADMIN_NUM_WORKS
    @page = (params[:page] || 1).to_i
    @works = Work.sortWorks(Work.all.offset(@numworks * (@page - 1)).limit(@numworks), (params[:sort_by].to_i || 0))
    @total_works = @works.size
  end

  def update
    if current_user.admin? && @work.update(work_params)
      redirect_to works_admin_path
    else
      format.html { redirect_to @user, notice: 'User was successfully updated.' }
    end
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
      if page < num_pages - 1 && page > 2
        first_array = Array(1)
        second_array = [page-1, page, page + 1]
        third_array = [num_pages]
      else
          first_array = Array(1..3)
          third_array = Array((num_pages-2)..num_pages)
      end
    else
      # simple paging
      first_array = Array(1..num_pages)
    end
    return [first_array, second_array, third_array]
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

    def get_user_category_works
      if current_user.admin?
        return Work.all
      elsif current_user.posters?
        return Work.getPostersWorks()
      elsif current_user.non_corporate?
        return Work.getNonCorpWorks(true)
      elsif current_user.corporate?
        # corporate can't see any non-available fine art
        return Work.getCorpWorks()
      end
    end

end


