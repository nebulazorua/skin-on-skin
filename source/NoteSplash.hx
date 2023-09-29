package;

import scripts.Globals;
import math.Vector3;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import shaders.ColorSwap;

class NoteSplash extends NoteObject
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;
	public var vec3Cache:Vector3 = new Vector3();

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';
		if (PlayState.splashSkin != null && PlayState.splashSkin.length > 0) 
			skin = PlayState.splashSkin;

		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		//antialiasing = ClientPrefs.globalAntialiasing;
	}

	public var animationAmount:Int = 2;
	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) 
	{
		if (FlxG.state == PlayState.instance){
			if (PlayState.instance.callOnHScripts("preSetupNoteSplash", [x, y, note, texture, hueColor, satColor, brtColor], ["this" => this, "noteData" => noteData]) == Globals.Function_Stop)
				return;
		}

		setPosition(x, y);
		animationAmount = 2;
		alpha = 0.6;
		scale.set(0.8, 0.8);
		updateHitbox();

		noteData = note;
		if (texture == null) {
			texture = 'noteSplashes';
			if (PlayState.splashSkin != null && PlayState.splashSkin.length > 0) texture = PlayState.splashSkin;
		}

		if (textureLoaded != texture) {
			var ret = Globals.Function_Continue;

			if (FlxG.state == PlayState.instance)
				ret = PlayState.instance.callOnHScripts("loadSplashAnims", [texture], ["this" => this, "noteData" => noteData]);
			
			if (ret != Globals.Function_Stop) 
				loadAnims(texture);
		}

		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;

		var ret = Globals.Function_Continue;
		if (FlxG.state == PlayState.instance)
			ret = PlayState.instance.callOnHScripts("postSetupNoteSplash", [x, y, note, texture, hueColor, satColor, brtColor], ["this" => this, "noteData" => noteData]);

		if (ret != Globals.Function_Stop){
			var playAnim = 'note$note';
			if (animationAmount > 1)
				playAnim += '-${FlxG.random.int(1, animationAmount)}';

			animation.play(playAnim, true);
			if (animation.curAnim != null) 
				animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		}
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...animationAmount+1)
		{
			animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
			animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
			animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
			animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
		}
	}

	override function update(elapsed:Float) 
	{
		if(animation.curAnim != null && animation.curAnim.finished) 
			kill();

		super.update(elapsed);
	}
}