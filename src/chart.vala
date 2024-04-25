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
    [GtkTemplate (ui = "/io/github/Graphin/ui/chart.ui")]
    public class Chart : Adw.Bin {
        public ChartItem chart { get; construct; }

        [GtkChild]
        public unowned Gtk.Frame frame;

        public Chart () {
            Object ();
        }

        construct {
            chart = new ChartItem ();
            frame.set_child (chart);
            frame.add_css_class ("frame");
        }
    }
}