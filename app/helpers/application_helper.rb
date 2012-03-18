module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    sort_icon = column == sort_column ? content_tag(:i, nil, class: (sort_direction == "asc" ? "icon-chevron-down" : "icon-chevron-up")) : ""
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to raw(title+" "+sort_icon), params.merge(:sort => column, :direction => direction, :page => nil)
  end
  
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  def page_navigation_links(pages)
    will_paginate(pages, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end

  
end
