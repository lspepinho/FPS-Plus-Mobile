package stages.data;

import shaders.AdjustColorShader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class PhillyErect extends BaseStage
{

	var characterShader:AdjustColorShader = new AdjustColorShader(-5, -26, 0, -16);

	var phillyCityLights:FlxSprite;
	var phillyCityLightsGlow:FlxSprite;

	var phillyTrain:FlxSprite;

	var trainSound:FlxSound;
	var unpauseSoundCheck:Bool = false;

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	var startedMoving:Bool = false;

	var windowColorIndex:Int = -1;
	final windowColors:Array<FlxColor> = [0xFFB66F43, 0xFF329A6D, 0xFF932C28, 0xFF2663AC, 0xFF502D64];

    public override function init(){
        name = "phillyErect";
		startingZoom = 1.1;

		var bg:FlxSprite = new FlxSprite(-100, 0).loadGraphic(Paths.image('week3/philly/erect/sky'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.1, 0.1);
		addToBackground(bg);

		var city:FlxSprite = new FlxSprite(-10, 0).loadGraphic(Paths.image('week3/philly/erect/city'));
		city.scrollFactor.set(0.3, 0.3);
		city.scale.set(0.85, 0.85);
		city.updateHitbox();
		city.antialiasing = true;
		addToBackground(city);

		phillyCityLights = new FlxSprite(-10, 0).loadGraphic(Paths.image("week3/philly/windowWhite"));
		phillyCityLights.scrollFactor.set(0.3, 0.3);
		phillyCityLights.scale.set(0.85, 0.85);
		phillyCityLights.updateHitbox();
		phillyCityLights.antialiasing = true;
		addToBackground(phillyCityLights);

		phillyCityLightsGlow = new FlxSprite(-10, 0).loadGraphic(Paths.image("week3/philly/windowWhiteGlow"));
		phillyCityLightsGlow.scrollFactor.set(0.3, 0.3);
		phillyCityLightsGlow.scale.set(0.85, 0.85);
		phillyCityLightsGlow.updateHitbox();
		phillyCityLightsGlow.antialiasing = true;
		phillyCityLightsGlow.blend = ADD;
		phillyCityLightsGlow.alpha = 0;
		addToBackground(phillyCityLightsGlow);

		changeLightColor();

		var behindTrain:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('week3/philly/erect/behindTrain'));
		behindTrain.antialiasing = true;
		addToBackground(behindTrain);

		phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('week3/philly/train'));
		phillyTrain.antialiasing = true;
		phillyTrain.visible = false;
		addToBackground(phillyTrain);

		trainSound = new FlxSound().loadEmbedded(Paths.sound('week3/train_passes'));
		FlxG.sound.list.add(trainSound);

		var street:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('week3/philly/erect/street'));
		street.antialiasing = true;
		addToBackground(street);

		dadStart.set(450, 875);
		bfStart.x += 50;

		dadCameraOffset.set(-50, 0);
		bfCameraOffset.set(-100, 0);

		boyfriend.applyShader(characterShader.shader);
		dad.applyShader(characterShader.shader);
		gf.applyShader(characterShader.shader);
    }

	public override function update(elapsed:Float){
		super.update(elapsed);

		if (trainMoving){
			trainFrameTiming += elapsed;

			if (trainFrameTiming >= 1 / 24){
				updateTrainPos();
				trainFrameTiming = 0;
			}
		}
	}

	public override function beat(curBeat){
		if (!trainMoving){
			trainCooldown += 1;
		}

		if (curBeat % 4 == 0){
			changeLightColor();
		}

		if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 12){
			trainCooldown = FlxG.random.int(0, 4);
			trainStart();
		}
	}

	public override function pause() {
		if(trainSound.playing){
			unpauseSoundCheck = true;
			trainSound.pause();
		}
	}

	public override function unpause() {
		if(unpauseSoundCheck){
			unpauseSoundCheck = false;
			trainSound.play(false);
		}
	}

	function changeLightColor(){
		windowColorIndex = FlxG.random.int(0, 4, [windowColorIndex]);
		phillyCityLights.color = windowColors[windowColorIndex];
		phillyCityLightsGlow.color = windowColors[windowColorIndex];
		FlxTween.cancelTweensOf(phillyCityLightsGlow);
		phillyCityLightsGlow.alpha = 1;
		FlxTween.tween(phillyCityLightsGlow, {alpha: 0}, (Conductor.crochet/1000) * 3.5, {ease: FlxEase.quadOut});
	}

	function trainStart():Void{
		trainMoving = true;
		trainSound.play(true);
	}

	function updateTrainPos():Void{
		if (trainSound.time >= 4700){
			startedMoving = true;
			gf.playAnim('hairBlow');
			phillyTrain.visible = true;
		}

		if (startedMoving){
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing){
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0){
					trainFinishing = true;
				}
			}

			if (phillyTrain.x < -4000 && trainFinishing){
				trainReset();
			}
		}
	}

	function trainReset():Void{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
		phillyTrain.visible = false;
	}
}