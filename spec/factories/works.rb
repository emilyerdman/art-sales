FactoryBot.define do
  factory :work do
    sequence(:inventory_number) {|n| "A-0000#{n}"}
    sequence(:title) {|n| "WORK NO. #{n}"}
    hinw {1}
    winw {2}
    retail_value {100.00}
    image {"images/link_to_image.jpg"}
    framed {true}
    frame_condition {"12 MAPLE"}
  end

  factory :not_dups, class: Work do
    sequence(:title) {|n| "NOT SAME #{n+5}"}
    sequence(:artist_id) {|n| n+5}
  end

end