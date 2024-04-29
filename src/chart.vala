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
        public ChartAxis? axis { get; construct; }
        public ChartGrid? grid { get; construct; }
        public ChartGestureHandler gesture_handler { get; construct; }
        public Gee.ArrayList<ChartSerie> series { get; default = new Gee.ArrayList<ChartSerie> (); }

        public Chart (ChartParameters parameters, ChartAxis? axis, ChartGrid? grid) {
            Object (parameters : parameters, axis : axis, grid : grid);
        }

        construct {
            this.content_width = 360;
            this.content_height = 480;

            this.gesture_handler = new ChartGestureHandler (this.parameters);

            Gtk.GestureZoom scale = new Gtk.GestureZoom ();
            scale.update.connect (this.queue_draw);
            scale.scale_changed.connect (gesture_handler.handle_scale);
            scale.end.connect (gesture_handler.current_scale_reset);

            Gtk.GestureDrag drag = new Gtk.GestureDrag ();
            drag.update.connect (this.queue_draw);
            drag.drag_update.connect (gesture_handler.handle_move);
            drag.drag_end.connect (gesture_handler.current_center_reset);

            this.add_controller (scale);
            this.add_controller (drag);

            this.set_draw_func (this.draw);
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