class WorksController < ApplicationController
  include Arel
  WORKS_SIZE = 10
  SORT_BY = 0

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
    @page = (params[:page] || 0).to_i
    @works_size = WORKS_SIZE
    @works = Work.all

    if params[:art_type].present?
      @works = @works.art_type_filter(params[:art_type])
    end

    if params[:availability].present?
      @works = @works.availability_filter(params[:availability])
    end

    if params[:corp_coll].present?
      @works = @works.corp_coll_filter
    end

    if params[:search].present?
      works_filtered = @works.search_filter(params[:search])
      puts Artist.artist_filter(params[:search]).size
      contacts_filtered = @works.where(artist_id: Artist.artist_filter(params[:search]))
      puts contacts_filtered
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

    @sort_by = (params[:sort_by]).to_i
    if @sort_by == 0
      @works = @works.order(inventory_number: :asc)
    elsif @sort_by == 1
      @works = @works.order(inventory_number: :desc) 
    elsif @sort_by == 2
      @works = @works.order(title: :desc)
    elsif @sort_by == 3
      @works = @works.order(title: :asc)
    elsif @sort_by == 4
      @works = @works.order(retail_value: :desc).where.not(retail_value: nil)
    elsif @sort_by == 5
      @works = @works.order(retail_value: :asc).where.not(retail_value: nil)
    end

    @total_works = @works.size
    @works = @works.offset(WORKS_SIZE * @page).limit(WORKS_SIZE)
  end

    



end
