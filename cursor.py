import os
import gi
import cairo
import warnings

# Suppress the dbind warning
warnings.filterwarnings("ignore", category=Warning)
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib

# Set NO_AT_BRIDGE environment variable
os.environ["NO_AT_BRIDGE"] = "1"

# Use the current open display or default to ':20' if not set.
current_display = os.environ.get("DISPLAY", ":20")
os.environ["DISPLAY"] = current_display

# Check Gtk initialization
if not Gtk.init_check():
    print("Gtk failed to initialize.")
    exit(1)

class CursorOverlay(Gtk.Window):

    def __init__(self):
        super(CursorOverlay, self).__init__()

        # Ensure the window is transparent
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)

        self.set_app_paintable(True)
        self.radius = 10
        self.set_default_size(self.radius*2, self.radius*2)
        self.set_decorated(False)
        self.set_keep_above(True)
        self.set_skip_taskbar_hint(True)
        self.stick()
        self.set_name('CursorOverlay')
        
        css = b'''
        #CursorOverlay {
            background-color: rgba(0, 0, 0, 0);
        }
        '''
        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            style_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        GLib.timeout_add(30, self.update_position)

    def after_show(self, widget, data=None):
        gdk_window = self.get_window()
        gdk_window.set_override_redirect(True)

        # Size of the window
        w, h = self.get_size()

        # Create a circular region for visual representation
        visual_surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, w, h)
        visual_cr = cairo.Context(visual_surface)
        visual_cr.set_source_rgba(1, 1, 1, 0.5)  # Set opacity to 0.5 here
        visual_cr.arc(self.radius, self.radius, self.radius, 0, 2 * 3.14159)
        visual_cr.fill()
        visual_region = Gdk.cairo_region_create_from_surface(visual_surface)
        gdk_window.shape_combine_region(visual_region, 0, 0)

        # Create a circular region for input so you can't click on the circle
        input_surface = cairo.ImageSurface(cairo.FORMAT_A1, w, h)
        input_cr = cairo.Context(input_surface)
        input_cr.arc(self.radius, self.radius, self.radius, 0, 2 * 3.14159)
        input_cr.set_operator(cairo.OPERATOR_CLEAR)
        input_cr.fill()
        input_region = Gdk.cairo_region_create_from_surface(input_surface)
        input_region = Gdk.cairo_region_create_from_surface(input_surface)
        gdk_window.input_shape_combine_region(input_region, 0, 0)

    def do_draw(self, cr, *args):
    	# Set color to red
    	cr.set_source_rgba(1, 0, 0, 0.5)  # Red

    	# Draw a circle with given radius
    	cr.arc(self.radius, self.radius, self.radius, 0, 2 * 3.14159)
    	cr.fill()

    def update_position(self):
        display = Gdk.Display.get_default()
        seat = display.get_default_seat()
        pointer = seat.get_pointer()
        _, x, y = pointer.get_position()
        self.move(int(x)-self.radius, int(y)-self.radius)
        return True

app = CursorOverlay()
app.connect('destroy', Gtk.main_quit)
app.connect('realize', app.after_show)
app.show_all()
Gtk.main()
