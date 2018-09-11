module JsDuck

  # Creates an array of small hashes documenting name, parent class
  # and icon of a class.
  class Icons
    def create(classes, opts)
      json = []
      classes.map do |cls|
        obj = {
          :name => cls[:name],
          :icon => Icons::class_icon(cls)
        }
        obj[:private] = true if cls[:private] || cls[:meta][:pseudo]
        obj[:isObject] = true if isObject(cls)
        obj[:extends] = cls[:extends] if cls[:extends]
        json.push(obj)
        # TIDOC-1071 Modifications to support Cloud DocTree
        if opts.rest
          cls[:members].each do |member|
            if member[:tagname].eql? :method and not(member[:deprecated])
              member_obj = {
                :name => cls[:name] + "." + member[:name],
                :url => cls[:name] + "-method-" + member[:name],
                :icon => "icon-component"
              }
              member_obj[:extends] = cls[:extends] if cls[:extends]
              member_obj[:private] = true if cls[:private] || cls[:meta][:pseudo]
              json.push(member_obj)
            end
          end
        end
      end
      json
    end

    def isObject(cls)
    	return cls[:meta][:typestr] && cls[:meta][:typestr][0].index("Object") == 0
    end

    def icon(cls)
      if cls[:singleton]
        "icon-singleton"
      elsif cls.inherits_from?("Ext.Component")
        "icon-component"
      elsif isObject(cls)
        "icon-object"
      else
        "icon-class"
      end
    end

    # Returns CSS class name for an icon of class
    def self.class_icon(cls)
      if cls[:singleton]
        "icon-singleton"
      elsif cls.inherits_from?("Ext.Component")
        "icon-component"
      else
        "icon-class"
      end
    end
  end

end
