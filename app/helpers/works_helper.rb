module WorksHelper

  def getPageCount(page, total_works, works_size)
    if (total_works == 0)
      return ''
    end
    start_count = (page * works_size) + 1
    end_count = (page * works_size) + works_size
    puts "start count %s\nend count %s\n total_size %s" % [start_count, end_count, total_works]
    if end_count > total_works
      end_count = total_works
    end
    return "%s - %s of %s" % [start_count, end_count, total_works]
  end

  def filterParams
    return params.permit(:corp_coll, :art_type, :availability, :sort_by, :page, :category_combo, :search, category:[])
  end

end
