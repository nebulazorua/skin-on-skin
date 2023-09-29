package modchart.modifiers;

import flixel.FlxSprite;
import modchart.*;
import math.*;
import playfields.NoteField;

class OpponentModifier extends NoteModifier {
	override function getName()
		return 'opponentSwap';

	inline function sign(x:Int)
		return x == 0 ? 0 : (x <= -1 ? -1 : 1);

	override function getPos(diff:Float, tDiff:Float, beat:Float, pos:Vector3, data:Int, player:Int, obj:FlxSprite, field:NoteField)
    {
		var distX = 640 / (modMgr.playerAmount * 0.5); // theres probably a way to optimize this (division is expensive!) but i think this is a good way of doing this rn

		pos.x += distX * sign((player + 1) * 2 - 3) * getValue(player);
		// any pN > 0 should go right whereas any pN < 0 should go left 
        return pos;
    }
}