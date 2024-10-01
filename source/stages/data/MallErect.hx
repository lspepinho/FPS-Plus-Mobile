package stages.data;

import shaders.AdjustColorShader;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class MallErect extends BaseStage
{
	var	characterShader:AdjustColorShader = new AdjustColorShader(0, 10, 0, 20);

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

    public override function init(){
        name = "mall-erect";
		startingZoom = 0.8;

		var bg:FlxSprite = new FlxSprite(-1000, -440).loadGraphic(Paths.image('week5/christmas/erect/bgWalls'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.2, 0.2);
		bg.active = false;
		bg.scale.set(0.9, 0.9);
		bg.updateHitbox();
		addToBackground(bg);

		upperBoppers = new FlxSprite(-240, -40);
		upperBoppers.frames = Paths.getSparrowAtlas("week5/christmas/erect/upperBop");
		upperBoppers.animation.addByPrefix('bop', "upperBop", 24, false);
		upperBoppers.antialiasing = true;
		upperBoppers.scrollFactor.set(0.33, 0.33);
		upperBoppers.scale.set(0.85, 0.85);
		upperBoppers.updateHitbox();
		addToBackground(upperBoppers);

		var bgEscalator:FlxSprite = new FlxSprite(-1100, -540).loadGraphic(Paths.image("week5/christmas/erect/bgEscalator"));
		bgEscalator.antialiasing = true;
		bgEscalator.scrollFactor.set(0.3, 0.3);
		bgEscalator.active = false;
		bgEscalator.scale.set(0.9, 0.9);
		bgEscalator.updateHitbox();
		addToBackground(bgEscalator);

		var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image("week5/christmas/erect/christmasTree"));
		tree.antialiasing = true;
		tree.scrollFactor.set(0.4, 0.4);
		addToBackground(tree);

		var fog:FlxSprite = new FlxSprite(-1000, 100).loadGraphic(Paths.image("week5/christmas/erect/white"));
		fog.antialiasing = true;
		fog.scale.set(0.9, 0.9);
		fog.updateHitbox();
		fog.scrollFactor.set(0.85, 0.85);
		addToBackground(fog);

		bottomBoppers = new FlxSprite(-410, 100);
		bottomBoppers.frames = Paths.getSparrowAtlas("week5/christmas/erect/bottomBop");
		bottomBoppers.animation.addByPrefix('bop', 'bottomBop', 24, false);
		bottomBoppers.antialiasing = true;
		bottomBoppers.scrollFactor.set(0.9, 0.9);
		addToBackground(bottomBoppers);

		var underSnow:FlxSprite = Utils.makeColoredSprite(5400, 3000, 0xFFF3F4F5);
		underSnow.setPosition(-1200, 800);
		underSnow.antialiasing = true;
		addToBackground(underSnow);

		var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image("week5/christmas/fgSnow"));
		fgSnow.active = false;
		fgSnow.antialiasing = true;
		addToBackground(fgSnow);

		santa = new FlxSprite(-840, 150);
		santa.frames = Paths.getSparrowAtlas("week5/christmas/santa");
		santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
		santa.animation.addByPrefix('idleLoop', 'santa idle in fear', 24, true);
		santa.animation.play("idleLoop", true);
		santa.antialiasing = true;
		santa.shader = characterShader.shader;
		addToForeground(santa);

		dadStart.set(42, 882);
		bfStart.set(1175.5, 866);
		gfStart.set(808.5, 845);

		bfCameraOffset.set(0, -70);

		boyfriend.applyShader(characterShader.shader);
		dad.applyShader(characterShader.shader);
		gf.applyShader(characterShader.shader);

		addEvent("mall-toggleSantaVisible", toggleSantaVisible);
    }

	public override function beat(curBeat:Int){
		upperBoppers.animation.play('bop', true);
		bottomBoppers.animation.play('bop', true);
		santa.animation.play('idle', true);
	}

	function toggleSantaVisible(tag:String) {
		santa.visible = !santa.visible;
	}
}