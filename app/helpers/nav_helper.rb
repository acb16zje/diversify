# frozen_string_literal: true

# Helper for creating navigation links
module NavHelper
  def navbar_link(name = nil, path = nil)
    link_to name, path, class: "navbar-item has-text-weight-semibold #{active?(path)}"
  end
end
