/* chart-serie.vala
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
    public abstract class ChartSerie : Object, IChartDrawable {
        protected double scale;
        protected Point center;
        public Gee.ArrayList<Point> points { get; default = new Gee.ArrayList<Point> (); }

        public abstract void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height);

        public void set_parameters (Point center, double scale) {
            this.center = center;
            this.scale = scale;
        }
    }
}