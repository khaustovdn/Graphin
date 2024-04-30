/* chart.vala
 *
 * Copyright 2024 khaustovdn
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.owned Gtk.EventController controller
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Graphin {
    public class Chart : Gtk.DrawingArea, IChartDrawable {
        public ChartParameters parameters { get; construct; }
        public ChartAxis? axis { get; set; }
        public ChartGrid? grid { get; set; }
        public ChartGestureHandler gesture_handler { get; construct; }
        public Gee.ArrayList<ChartSerie> series { get; default = new Gee.ArrayList<ChartSerie> (); }

        public Chart (Point center, double zoom, ChartAxisStatus axis_status, ChartGridStatus grid_status) {
            Object (parameters : new ChartParameters (new Point (center.x, center.y), zoom));
            axis = (axis_status == ChartAxisStatus.ENABLE) ? new ChartAxis (this.parameters) : null;
            grid = (grid_status == ChartGridStatus.ENABLE) ? new ChartGrid (this.parameters) : null;
        }

        construct {
            this.content_width = 360;
            this.content_height = 480;

            this.parameters = new ChartParameters (new Point (this.parameters.center.x, this.content_height - this.parameters.center.y), this.parameters.zoom);
            this.gesture_handler = new ChartGestureHandler (this.parameters);

            this.setup_gestures ();

            this.set_draw_func (this.draw);
        }

        private void setup_gestures () {
            Gtk.GestureZoom zoom = new Gtk.GestureZoom ();
            zoom.scale_changed.connect (gesture_handler.handle_zoom);
            zoom.end.connect (gesture_handler.zoom_reset);

            Gtk.EventControllerScroll scroll = new Gtk.EventControllerScroll (Gtk.EventControllerScrollFlags.BOTH_AXES);
            scroll.scroll.connect (gesture_handler.handle_scroll);
            scroll.scroll_end.connect (gesture_handler.zoom_reset);

            Gtk.GestureDrag drag = new Gtk.GestureDrag ();
            drag.drag_update.connect (gesture_handler.handle_drag);
            drag.drag_end.connect (gesture_handler.center_reset);

            this.parameters.notify["zoom"].connect (this.queue_draw);
            this.parameters.notify["center"].connect (this.queue_draw);

            this.add_controller (zoom);
            this.add_controller (scroll);
            this.add_controller (drag);
        }

        private void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            if (this.axis != null)this.axis.draw (drawing_area, cairo, width, height);
            if (this.grid != null)this.grid.draw (drawing_area, cairo, width, height);
            foreach (var serie in this.series) {
                serie.draw (drawing_area, cairo, width, height);
            }
        }
    }
}