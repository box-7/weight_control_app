class Relationship < ApplicationRecord
    # follower、followedはここで定義している
    # class_name: "User"でUserモデルを参照。フォローする人、フォローされる人を分ける
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
end
