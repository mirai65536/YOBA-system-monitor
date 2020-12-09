/*
 * Copyright (c) 2020, Мира Странная <rsxrwscjpzdzwpxaujrr@yahoo.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtGraphicalEffects 1.12

Canvas {
    id: root

    property int size: 400
    property real value: 0.0

    width: size
    height: size * 0.88

    property real markLength: 30
    property real markOffset: 10

    property real startAngle: 45 * (Math.PI / 180)
    property real endAngle: 315 * (Math.PI / 180)

    clip: true

    Rectangle {
        id: background

        z: -2

        width: size
        height: size

        radius: size / 2
        color: "#002b36"

        layer.enabled: true
        layer.effect: InnerShadow {
            horizontalOffset: 0
            verticalOffset: 20
            radius: 40.0
            samples: 12
            color: "#30000000"
        }
    }

    onPaint: {
        var ctx = getContext("2d");

        ctx.clearRect(0, 0, width, height);
        ctx.translate(size / 2, size / 2);
        ctx.shadowBlur = 10;

        let markStart = markOffset;
        let step = (endAngle - startAngle) / 20;

        for (let i = startAngle, line = 0; i <= endAngle; i += step, line++) {
            let markEnd;
            let halfSize = size / 2;

            if (line <= 11) {
                ctx.strokeStyle = "#859900";
            } else if (line > 17) {
                ctx.strokeStyle = "#dc322f";
            } else {
                ctx.strokeStyle = "#cb4b16";
            }

            if (line % 2 == 0) {
                ctx.shadowColor = ctx.strokeStyle;
                ctx.lineWidth = 12

                markEnd = markStart + markLength
            } else {
                ctx.shadowColor = "#00000000";
                ctx.lineWidth = 6

                ctx.strokeStyle = "#60" + ctx.strokeStyle.substring(7, 1);

                markEnd = markStart + markLength / 2
            }

            ctx.beginPath();
            ctx.moveTo(
                (-Math.sin(i) * (halfSize - markStart)),
                ( Math.cos(i) * (halfSize - markStart))
            );

            ctx.lineTo(
                (-Math.sin(i) * (halfSize - markEnd)),
                ( Math.cos(i) * (halfSize - markEnd))
            );

            ctx.stroke();
        }

        ctx.translate(-size / 2, -size / 2);
    }

    Canvas {
        id: pointer

        anchors.fill: parent

        property real angle: (value * (315 - 45)) - 180 + 45

        transform: Rotation {
            id: rotation

            origin.x: size / 2
            origin.y: size / 2

            angle: pointer.angle
        }

        onPaint: {
            var ctx = getContext("2d");

            ctx.clearRect(0, 0, pointer.width, pointer.height);
            ctx.translate(size / 2, size / 2);

            let halfSize = size / 2;
            let length = halfSize * 0.9;
            let width = 20;

            ctx.beginPath();

            ctx.moveTo( 0,      width + 10);
            ctx.lineTo( width,  10);
            ctx.lineTo( 0,     -length);
            ctx.lineTo(-width,  10);

            ctx.closePath();

            ctx.fillStyle = "#d33682"
            ctx.fill();

            ctx.translate(-size / 2, -size / 2);
        }

        layer.enabled: true
        layer.effect: DropShadow {
            id: shadow
            horizontalOffset: Math.sin(pointer.angle * (Math.PI / 180)) * 6
            verticalOffset: Math.cos(pointer.angle * (Math.PI / 180)) * 6
            radius: 12.0
            samples: 6
            color: "#40000000"
        }
    }
}
