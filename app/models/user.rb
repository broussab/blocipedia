class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis, dependent: :destroy
  has_many :collaborators
  has_many :collab_wikis, through: :collaborators, class_name: 'Wiki', source: :wiki
  after_initialize { self.role ||= :standard }

  enum role: [:standard, :premium, :admin]

  def wikis_to_public
    wikis.update_all(private: false)
  end
end
