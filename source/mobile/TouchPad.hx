package mobile;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import mobile.input.MobileInputManager;
import mobile.input.MobileInputID;

/**
 * ...
 * @author: Karim Akra and Lily Ross (mcagabe19)
 */
@:access(mobile.TouchButton)
class TouchPad extends MobileInputManager
{
	public var buttonLeft:TouchButton = new TouchButton(0, 0, [MobileInputID.LEFT]);
	public var buttonUp:TouchButton = new TouchButton(0, 0, [MobileInputID.UP]);
	public var buttonRight:TouchButton = new TouchButton(0, 0, [MobileInputID.RIGHT]);
	public var buttonDown:TouchButton = new TouchButton(0, 0, [MobileInputID.DOWN]);
	public var buttonLeft2:TouchButton = new TouchButton(0, 0, [MobileInputID.LEFT2]);
	public var buttonUp2:TouchButton = new TouchButton(0, 0, [MobileInputID.UP2]);
	public var buttonRight2:TouchButton = new TouchButton(0, 0, [MobileInputID.RIGHT2]);
	public var buttonDown2:TouchButton = new TouchButton(0, 0, [MobileInputID.DOWN2]);
	public var buttonA:TouchButton = new TouchButton(0, 0, [MobileInputID.A]);
	public var buttonB:TouchButton = new TouchButton(0, 0, [MobileInputID.B]);
	public var buttonC:TouchButton = new TouchButton(0, 0, [MobileInputID.C]);
	public var buttonD:TouchButton = new TouchButton(0, 0, [MobileInputID.D]);
	public var buttonE:TouchButton = new TouchButton(0, 0, [MobileInputID.E]);
	public var buttonF:TouchButton = new TouchButton(0, 0, [MobileInputID.F]);
	public var buttonG:TouchButton = new TouchButton(0, 0, [MobileInputID.G]);
	public var buttonH:TouchButton = new TouchButton(0, 0, [MobileInputID.H]);
	public var buttonI:TouchButton = new TouchButton(0, 0, [MobileInputID.I]);
	public var buttonJ:TouchButton = new TouchButton(0, 0, [MobileInputID.J]);
	public var buttonK:TouchButton = new TouchButton(0, 0, [MobileInputID.K]);
	public var buttonL:TouchButton = new TouchButton(0, 0, [MobileInputID.L]);
	public var buttonM:TouchButton = new TouchButton(0, 0, [MobileInputID.M]);
	public var buttonN:TouchButton = new TouchButton(0, 0, [MobileInputID.N]);
	public var buttonO:TouchButton = new TouchButton(0, 0, [MobileInputID.O]);
	public var buttonP:TouchButton = new TouchButton(0, 0, [MobileInputID.P]);
	public var buttonQ:TouchButton = new TouchButton(0, 0, [MobileInputID.Q]);
	public var buttonR:TouchButton = new TouchButton(0, 0, [MobileInputID.R]);
	public var buttonS:TouchButton = new TouchButton(0, 0, [MobileInputID.S]);
	public var buttonT:TouchButton = new TouchButton(0, 0, [MobileInputID.T]);
	public var buttonU:TouchButton = new TouchButton(0, 0, [MobileInputID.U]);
	public var buttonV:TouchButton = new TouchButton(0, 0, [MobileInputID.V]);
	public var buttonW:TouchButton = new TouchButton(0, 0, [MobileInputID.W]);
	public var buttonX:TouchButton = new TouchButton(0, 0, [MobileInputID.X]);
	public var buttonY:TouchButton = new TouchButton(0, 0, [MobileInputID.Y]);
	public var buttonZ:TouchButton = new TouchButton(0, 0, [MobileInputID.Z]);

	public var instance:MobileInputManager;

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(DPad:String, Action:String)
	{
		super();

		if (DPad != "NONE")
		{
			if (!MobileData.dpadModes.exists(DPad))
				throw 'The touchPad dpadMode "$DPad" doesn\'t exists.';

			for (buttonData in MobileData.dpadModes.get(DPad).buttons)
			{
				Reflect.setField(this, buttonData.button,
					createButton(buttonData.x, buttonData.y, buttonData.graphic, Utils.colorFromString(buttonData.color),
						Reflect.getProperty(this, buttonData.button).IDs));
				add(Reflect.field(this, buttonData.button));
			}
		}

		if (Action != "NONE")
		{
			if (!MobileData.actionModes.exists(Action))
				throw 'The touchPad actionMode "$Action" doesn\'t exists.';

			for (buttonData in MobileData.actionModes.get(Action).buttons)
			{
				Reflect.setField(this, buttonData.button,
					createButton(buttonData.x, buttonData.y, buttonData.graphic, Utils.colorFromString(buttonData.color),
						Reflect.getProperty(this, buttonData.button).IDs));
				add(Reflect.field(this, buttonData.button));
			}
		}

		alpha = config.Config.mobileCAlpha;
		scrollFactor.set();
		updateTrackedButtons();

		instance = this;
	}

	override public function destroy()
	{
		super.destroy();

		for (fieldName in Reflect.fields(this))
		{
			var field = Reflect.field(this, fieldName);
			if (Std.isOfType(field, TouchButton))
				Reflect.setField(this, fieldName, FlxDestroyUtil.destroy(field));
		}
	}

	private function createButton(X:Float, Y:Float, Graphic:String, ?Color:FlxColor = 0xFFFFFF, ?IDs:Array<MobileInputID>):TouchButton
	{
		var button = new TouchButton(X, Y, IDs);
		button.label = new FlxSprite();
		button.loadGraphic('assets/mobile/images/touchpadBG.png');
		button.label.loadGraphic('assets/mobile/images/touchpad/${Graphic.toUpperCase()}.png');

		button.scale.set(0.243, 0.243);
		button.updateHitbox();
		button.updateLabelPosition();

		button.statusBrightness = [1, 0.8, 0.4];
		button.statusIndicatorType = BRIGHTNESS;
		button.indicateStatus();

		button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
		button.centerBounds();

		button.immovable = true;
		button.solid = button.moves = false;
		button.label.antialiasing = button.antialiasing = true;
		button.tag = Graphic.toUpperCase();
		button.color = Color;
		button.parentAlpha = button.alpha;
		return button;
	}

	override function set_alpha(Value):Float
	{
		forEachAlive((button:TouchButton) -> button.parentAlpha = Value);
		return super.set_alpha(Value);
	}
}
