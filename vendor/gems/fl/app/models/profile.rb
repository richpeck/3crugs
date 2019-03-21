class Profile < ApplicationRecord

  ###########################################################
  ###########################################################
  ##              _____           __ _ _                   ##
  ##             | ___ \         / _(_) |                  ##
  ##             | |_/ / __ ___ | |_ _| | ___              ##
  ##             |  __/ '__/ _ \|  _| | |/ _ \             ##
  ##             | |  | | | (_) | | | | |  __/             ##
  ##             \_|  |_|  \___/|_| |_|_|\___|             ##
  ##                                                       ##
  ###########################################################
  ###########################################################
  ##        Adds extra stuff for user profiles etc         ##
  ###########################################################
  ###########################################################

    # => User
    belongs_to :user, inverse_of: :profile

    # => Avatar
    # => ActiveStorage (not Paperclip as was the case before)
    has_one_attached :avatar
    validate :format

    # => Name
    alias_attribute :ref, :name
    validates :name, length: { minimum: 2 }, allow_blank: true # => http://stackoverflow.com/a/22323406/1143732

    # => Blanks
    nilify_blanks only: [:name]

    # => Roles
    enum role: [:user, :admin]

    # => Slug
    extend FriendlyId
    friendly_id :name

  ###########################################################
  ###########################################################

  # Class (public)
  ###################


  # Instance (private)
  ###################

    # => First Name
    def first_name
      name.try(:split).try(:first)
    end

    # => Name
    # => If no name, use email
    def name
      self[:name] || user.email
    end

    private

    # => Avatar uploads
    def format
      return unless avatar.attached?
      return if avatar.blob.content_type.start_with? 'image/'
      avatar.purge
      errors.add(:avatar, 'needs to be an image')
    end

  ###########################################################
  ###########################################################

end
