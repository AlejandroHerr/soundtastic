
local options = {
  popup_width = 40,
  popup_height = 200,
  bar_height = 150,
  bar_width = 15,
}
local label = wibox.widget({
    text   = "50%",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
})


local slider = wibox.widget({
            --  bar_shape           = gears.shape.rounded_rect,
            bar_height          = options.bar_width,
            bar_color           = beautiful.border_color,
            handle_color        = beautiful.bg_normal,
            --handle_shape        = gears.shape.circle,
            handle_width = 30,
            --handle_width = 2,
            handle_margins = 0,
            handle_border_color = "#ffffff",
            handle_border_width = 1,
            value               = 25,
            widget              = wibox.widget.slider,
          })


  local lay_slider = {
    
      {
        {
          slider,
        direction = 'east',
        widget    = wibox.container.rotate
      },
      --strategy = "max",
      width    = options.bar_width,
      height = options.bar_height,
      widget   = wibox.container.constraint
    },
    top = 5,
    bottom = 5,
    right = (options.popup_width - options.bar_width) / 2,
    left = (options.popup_width - options.bar_width) / 2,
    widget = wibox.container.margin,

  }
  local mytextwraper = {
    label,
    height = 50,
    width = 100,
    widget = wibox.container.constraint,
    }
  local mywraper = {
    label,
    lay_slider,
    mytextwraper,
    height = 150,
    width = 10,
    widget = wibox.layout.fixed.vertical,
    }
  
  local mywraper2 = wibox.widget({
    mywraper,
    layout  = wibox.layout.fixed.horizontal,
    })

  local bar = wibox ({
    ontop = true,
    visible = true,
    x = 10,
    y = 100,
    width = options.popup_width,
    height = 200,
    screen = s,
    type = "dock",
    opacity = 1,
    widget = mywraper2,
  })


function bar.update(volume)
  label.text = tostring( volume ) .. "%"
  slider.value = volume
end

function bar.getSlider()
  return slider
end

return bar

 -- return bar