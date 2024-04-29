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
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Graphin {
    public class Chart : Gtk.DrawingArea, IChartDrawable {
        public ChartParameters parameters { get; construct; }
        private ChartAxis axis { get; default = new ChartAxis (); }
        private ChartGrid grid { get; default = new ChartGrid (); }
        public ChartGestureHandler gesture_handler { private get; construct; }
        public Gee.ArrayList<ChartSerie> series { get; default = new Gee.ArrayList<ChartSerie> (); }

        public Chart () {
            Object ();
        }

        construct {
            this.content_width = 360;
            this.content_height = 480;
            this.parameters = new ChartParameters (new Point (20.0, this.content_height - 20.0), 1.0);
            this.gesture_handler = new ChartGestureHandler (this);
            this.set_draw_func (this.draw_func);
        }

        private void draw_func (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            this.draw (drawing_area, cairo, width, height, this.parameters);
        }

        private void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height, ChartParameters parameters) {
            this.axis.draw (drawing_area, cairo, width, height, parameters);
            this.grid.draw (drawing_area, cairo, width, height, parameters);
            foreach (var serie in this.series) {
                serie.draw (drawing_area, cairo, width, height, parameters);
            }
        }
    }
}