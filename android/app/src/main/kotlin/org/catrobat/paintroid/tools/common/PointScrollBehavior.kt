/*
 * Paintroid: An image manipulation application for Android.
 *  Copyright (C) 2010-2022 The Catrobat Team
 * (<http://developer.catrobat.org/credits>)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.catrobat.paintroid.tools.common

import android.graphics.Point

class PointScrollBehavior(private val scrollTolerance: Int) : ScrollBehavior {
    override fun getScrollDirection(
        pointX: Float,
        pointY: Float,
        viewWidth: Int,
        viewHeight: Int
    ): Point {
        var deltaX = 0
        var deltaY = 0
        if (pointX < scrollTolerance) {
            deltaX = 1
        }
        if (pointX > viewWidth - scrollTolerance) {
            deltaX = -1
        }
        if (pointY < scrollTolerance) {
            deltaY = 1
        }
        if (pointY > viewHeight - scrollTolerance) {
            deltaY = -1
        }
        return Point(deltaX, deltaY)
    }
}
