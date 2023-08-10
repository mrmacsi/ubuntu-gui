import os
import gi
import cairo  # New Import

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GdkPixbuf, GLib

class CursorOverlay(Gtk.Window):
    def __init__(self):
        super(CursorOverlay, self).__init__()

        # Set the window type hint to be above other applications and transparent
        self.set_type_hint(Gdk.WindowTypeHint.SPLASHSCREEN)
        self.set_opacity(0.5)
        self.set_decorated(False)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)

        # Define the dimensions for the circle around the cursor
        self.radius = 20

        # Add a timeout function to update the position of the window (circle) to be under the cursor
        GLib.timeout_add(30, self.update_position)

        # Load transparent background
        self.background = GdkPixbuf.Pixbuf.new(GdkPixbuf.Colorspace.RGB, True, 8, self.radius*2, self.radius*2)
        self.background.fill(0x00000000)

        # Draw the circle
        self.surface = Gdk.cairo_surface_create_from_pixbuf(self.background, 1, None)
        self.context = cairo.Context(self.surface)
        self.context.arc(self.radius, self.radius, self.radius, 0, 2*3.14159)
        self.context.set_line_width(3)
        self.context.set_source_rgba(1.0, 0, 0, 0.8)
        self.context.stroke()

        # Update initial position
        self.update_position()

    def update_position(self):
        display = Gdk.Display.get_default()
        pointer = display.get_device_manager().get_client_pointer()
        window, x, y, _ = pointer.get_position()
        self.move(x - self.radius, y - self.radius)
        return True

    # This method makes the window non-interactive to mouse events
    def after_show(self, widget):
        self.set_input_shape_combine_region(None)

    def do_draw(self, cr):
        Gdk.cairo_set_source_pixbuf(cr, Gdk.pixbuf_get_from_surface(self.surface, 0, 0, self.radius*2, self.radius*2), 0, 0)
        cr.paint()


if __name__ == '__main__':
    os.environ['NO_AT_BRIDGE'] = '1'
    print("Using DISPLAY:", os.environ.get("DISPLAY", "Not found"))
    
    app = CursorOverlay()
    app.connect('destroy', Gtk.main_quit)
    app.connect('show', app.after_show)  # Connect the show event to after_show method
    app.show_all()
    Gtk.main()
