module WorksHelper

  def getPageCount(page, total_works, numworks)
    page = page - 1
    if (total_works == 0)
      return ''
    end
    start_count = (page * numworks) + 1
    end_count = (page * numworks) + numworks
    if end_count > total_works
      end_count = total_works
    end
    return "%s - %s of %s" % [start_count, end_count, total_works]
  end

  def filterParams
    return params.permit(:corp_coll, :collection, :art_type, :availability, :framed, :sort_by, :page, :category_combo, :search, :numworks, category:[])
  end



end
