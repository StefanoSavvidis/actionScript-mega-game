package  {
	
	/* All Imports */
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.geom.Point;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.net.Socket;
	import flash.text.TextFormat;
	import flashx.textLayout.accessibility.TextAccImpl;
	
	
	public class MainSum extends MovieClip {
		
		
		var enemyMelee:EnemyMelee = new EnemyMelee();
		var enemyRange:EnemyRange = new EnemyRange();
		var enemyMeleeProperties:Array = new Array();
		var enemyRangeProperties:Array = new Array();
		
		
		var blockAStates:Array = new Array(); 

		var menu:TitleScreen = new TitleScreen();
		var playMenu:PlayScreen = new PlayScreen();
		var helpMenu:HelpScreen = new HelpScreen();
		
		var mega:Mega = new Mega();
		
		var timeInLevel = 0;
		
		var level:LevelOne = new LevelOne();
		var scene:GameScene = new GameScene();
		var levelFinished:Boolean = false;
		
		var meleeEnemies = 0;
		var rangeEnemies = 0;
		var totalEnemies = 0;
		
		var gameSpeed = 8;
		var slowMultiplier = 1;
		var normalSpeed = 1;
		var slowSpeed = 0.5;
		var fastSpeed = 1.4;
		
		var healthText:TextField = new TextField();
		var healthFormat:TextFormat = new TextFormat;
		
		var selectedLevel = 0;
		
		var previousLevel = 0;
		var currentLevel = 0;
		
		var myChannel:SoundChannel = new SoundChannel();
		
		var megaShoot:Sound = new MegaShoot();
		var enemyHit:Sound = new EnemyHit();
		var megaHit:Sound = new MegaHit();
		var megaDeath:Sound = new MegaDeath();
		var enemyShoot:Sound = new EnemyShoot();
		var megaSlide:Sound = new MegaSlide();
		
		var enemyMaxHealth = 0;
		
		var xGon:Sound = new XGon();
		var baby:Sound = new Baby();
		var bitMusic:Sound = new BitMusic();
		
		var numOfSand = 0;
		var numOfIce = 0;
		
		var currScreen = 1;
		var finalScreen = 0;
		
		var difficulty = 2;
		
		var numOfABlocks = 1;
		var numOfBBlocks = 1;
		
		var gravity:Number = 0.8;
		
		var filter:Filter = new Filter();
		var winScreen:WinScreen = new WinScreen();
		var gameOver:GameOver = new GameOver ();
		
		var running:Boolean = false;
		var sliding:Boolean = false;
		var attacking:Boolean = false;
		var shooting:Boolean = false;
		var canShoot:Boolean = true;
		
		var allEnemiesDead:Boolean = true;
		
		var megaHealth = 10;
		var invincibleTime = 0;
		var timeToRegen = 40;
		var megaInvincible:Boolean = false;
		
		var shotDirection:Array = new Array();
		var enemyShotDirection:Array = new Array();
		
		var timeToShoot = 0;
		var shootReload = 12;
		var amountShot = 0;
		
		var enemyAmountShot = 0;
		
		var slideCount = 0;
		
		public function MainSum() {
			
			/* Block A States */
			blockAStates[0] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[1] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[2] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[3] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[4] = ["Still", "Normal", 0, 1, 1];  
			blockAStates[5] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[6] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[7] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[8] = ["Still", "Normal", 0, 1, 1]; 
			blockAStates[9] = ["Still", "Normal", 0, 1, 1]; 
			
			addChild(menu);
			
			menu.gameButton.addEventListener(MouseEvent.CLICK, menuChoice);
			menu.helpButton.addEventListener(MouseEvent.CLICK, menuChoice);
			
		}
		
		/* Menu Options*/
		public function	menuChoice(me:MouseEvent)
		{	
			if (me.target.name == "gameButton")
			{
				removeChild(menu);
				addChild(playMenu);
				
			}
			else if(me.target.name == "helpButton")
			{
				removeChild(menu);
				addChild(helpMenu);
			}
			
			playMenu.Easy.addEventListener(MouseEvent.CLICK, difficultyChoice);
			playMenu.Normal.addEventListener(MouseEvent.CLICK, difficultyChoice);
			playMenu.Hard.addEventListener(MouseEvent.CLICK, difficultyChoice);
			
			playMenu.levelOne.addEventListener(MouseEvent.CLICK, loadLevel);
			playMenu.levelTwo.addEventListener(MouseEvent.CLICK, loadLevel);
			playMenu.levelThree.addEventListener(MouseEvent.CLICK, loadLevel);
			playMenu.levelFour.addEventListener(MouseEvent.CLICK, loadLevel);
			playMenu.levelFive.addEventListener(MouseEvent.CLICK, loadLevel);
			
			playMenu.backToMenuPlay.addEventListener(MouseEvent.CLICK, backToMenu);
			helpMenu.backToMenuHelp.addEventListener(MouseEvent.CLICK, backToMenu);
			
		}
		

		
		public function difficultyChoice (me:MouseEvent)
		{
			if (me.target.name == "Easy")
			{
				difficulty = 1;
				playMenu.difficultySelector.x = 200;
			}
			else if (me.target.name == "Normal")
			{
				difficulty = 2;
				playMenu.difficultySelector.x = 400;
			}
			else if (me.target.name == "Hard")
			{
				difficulty = 3;
				playMenu.difficultySelector.x = 600;
			}
		}
		
		public function	loadLevel(me:MouseEvent)
		{	
			
			megaHealth = 10;
			timeInLevel = 0;
			// ENEMY Melee PROPERTIES   scaleX, speed, health, alive, alpha
			enemyMeleeProperties[0] = [1, 7, 5, 1, 1];
			enemyMeleeProperties[1] = [1, 7, 5, 1, 1];
			enemyMeleeProperties[2] = [1, 7, 5, 1, 1];
			enemyMeleeProperties[3] = [1, 7, 5, 1, 1];
			enemyMeleeProperties[4] = [1, 7, 5, 1, 1];
			enemyMeleeProperties[5] = [1, 7, 5, 1, 1];
			// ENEMY PROPERTIES   scaleX, speed, health, alive, alpha,
			enemyRangeProperties[0] = [1, 4, 5, 1, 1, 0, 24, 1, 1];
			enemyRangeProperties[1] = [1, 4, 5, 1, 1, 0, 24, 1, 1];
			enemyRangeProperties[2] = [1, 4, 5, 1, 1, 0, 24, 1, 1];
			enemyRangeProperties[3] = [1, 4, 5, 1, 1, 0, 24, 1, 1];
			enemyRangeProperties[4] = [1, 4, 5, 1, 1, 0, 24, 1, 1];
			enemyRangeProperties[5] = [1, 4, 5, 1, 1, 0, 24, 1, 1];
			
			addChild(scene);
			addChild(level);
			
			scene.x = 0;
			mega.x = 50;
			mega.y = 400;
			
			previousLevel = selectedLevel;
			
			if (me.target.name == "levelOne")
			{
				selectedLevel = 1;
			}
			else if (me.target.name == "levelTwo")
			{
				selectedLevel = 2;
			}
			else if (me.target.name == "levelThree")
			{
				selectedLevel = 3;
			}
			else if (me.target.name == "levelFour")
			{
				selectedLevel = 4;
			}
			else if (me.target.name == "levelFive")
			{
				selectedLevel = 5;
			}
			
			/* If level change reset block A States */
			if (previousLevel != selectedLevel)
			{
				blockAStates[0] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[1] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[2] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[3] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[4] = ["Still", "Normal", 0, 1, 1];  
				blockAStates[5] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[6] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[7] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[8] = ["Still", "Normal", 0, 1, 1]; 
				blockAStates[9] = ["Still", "Normal", 0, 1, 1]; 
			}
			
			/* DECLARE COMPONENTS OF LEVEL */
			if (me.target.name == "levelOne")
			{
				
				level.gotoAndStop (1);
				scene.gotoAndStop (1);
				
				selectedLevel = 1;
				finalScreen = 4;
				currScreen = 1;
				numOfABlocks = 9;
				numOfBBlocks = 1;
				
				meleeEnemies = 1;
				rangeEnemies = 1;
				
				
				blockAStates[0][1] = "Sand"; 
				blockAStates[1][1] = "Sand"; 
				blockAStates[2][1] = "Sand"; 
				blockAStates[3][1] = "Ice"; 
				blockAStates[4][0] = "Vertical";  
				blockAStates[5][0] = "Horizantel"; 
	
				
				enemyRangeProperties[0][7] = 0;
				
			}
			else if(me.target.name == "levelTwo")
			{
				level.gotoAndStop (2);
				scene.gotoAndStop (2);
				
				selectedLevel = 2;
				finalScreen = 3;
				currScreen = 1;
				numOfABlocks = 7;
				numOfBBlocks = 2;
				
				meleeEnemies = 1;
				rangeEnemies = 3;
				
				enemyRangeProperties[0][7] = 0;
				enemyRangeProperties[1][7] = 0;
				
				blockAStates[3][1] = "Sand";
				blockAStates[5][1] = "Sand";
			}	
			else if(me.target.name == "levelThree")
			{
				level.gotoAndStop (3);
				scene.gotoAndStop (3);
				
				selectedLevel = 3;
				finalScreen = 4;
				currScreen = 1;
				numOfABlocks = 4;
				numOfBBlocks = 1;
				
				meleeEnemies = 6;
				rangeEnemies = 4;
				
				enemyRangeProperties[0][7] = 0;
				enemyRangeProperties[1][7] = 0;
				enemyRangeProperties[2][7] = 0;
				enemyRangeProperties[3][7] = 0;
				
				blockAStates[1][1] = "Sand";
				blockAStates[2][1] = "Sand";
				blockAStates[3][1] = "Sand";
			}	
			else if(me.target.name == "levelFour")
			{
				level.gotoAndStop (4);
				scene.gotoAndStop (4);
				
				selectedLevel = 4;
				finalScreen = 3;
				currScreen = 1;
				
				numOfABlocks = 10;
				numOfBBlocks = 2;
				
				meleeEnemies = 2;
				rangeEnemies = 5;
				
				enemyRangeProperties[0][7] = 0;
				enemyRangeProperties[1][7] = 0;
				enemyRangeProperties[2][7] = 0;
				enemyRangeProperties[3][7] = 0;
				enemyRangeProperties[4][7] = 0;
				
				blockAStates[0][0] = "Vertical";
				blockAStates[1][0] = "Vertical";
				blockAStates[1][4] = -1;
				blockAStates[3][0] = "Vertical";
				blockAStates[4][0] = "Vertical";
				blockAStates[4][4] = -1;
				blockAStates[6][1] = "Sand";
				blockAStates[7][1] = "Sand";
				blockAStates[8][1] = "Sand";

			}	
			else if(me.target.name == "levelFive")
			{
				level.gotoAndStop (5);
				scene.gotoAndStop (5);
				
				selectedLevel = 5;
				finalScreen = 2;
				currScreen = 1;
				
				numOfABlocks = 6;
				numOfBBlocks = 6;
				
				meleeEnemies = 4;
				rangeEnemies = 4;
				
				blockAStates[0][1] = "Ice";
				blockAStates[1][1] = "Ice";
				blockAStates[2][1] = "Ice";
				blockAStates[3][1] = "Ice";
				blockAStates[4][1] = "Ice";
				
			}	

			mega.xSpeed = 0;
			mega.ySpeed = 0;
			mega.jump = false;
			
			// Change health and damage and fire rate based on difficulty
			if (difficulty == 1)
			{
				myChannel = baby.play();
				enemyMaxHealth = 3;
				for(var enemyMeleeDifficulty1:int = 0; enemyMeleeDifficulty1 < meleeEnemies; enemyMeleeDifficulty1++)
				{
					enemyMeleeProperties[enemyMeleeDifficulty1][1] = 4;
					enemyMeleeProperties[enemyMeleeDifficulty1][2] = 3;
				}
				for(var enemyRangeDifficulty1:int = 0; enemyRangeDifficulty1 < rangeEnemies; enemyRangeDifficulty1++)
				{
					enemyRangeProperties[enemyRangeDifficulty1][1] = 2;
					enemyRangeProperties[enemyRangeDifficulty1][2] = 3;
					enemyRangeProperties[enemyRangeDifficulty1][6] = 48;
				}
			}
			else if (difficulty == 2)
			{
				myChannel = bitMusic.play();
				enemyMaxHealth = 5;
				for(var enemyMeleeDifficulty2:int = 0; enemyMeleeDifficulty2 < meleeEnemies; enemyMeleeDifficulty2++)
				{
					enemyMeleeProperties[enemyMeleeDifficulty2][1] = 7;
					enemyMeleeProperties[enemyMeleeDifficulty2][2] = 5;
				}
				for(var enemyRangeDifficulty2:int = 0; enemyRangeDifficulty2 < rangeEnemies; enemyRangeDifficulty2++)
				{
					enemyRangeProperties[enemyRangeDifficulty2][1] = 4;
					enemyRangeProperties[enemyRangeDifficulty2][2] = 5;
					enemyRangeProperties[enemyRangeDifficulty2][6] = 36;
				}
			}
			else if (difficulty == 3)
			{
				
				myChannel = xGon.play();
				enemyMaxHealth = 8;
				for(var enemyMeleeDifficulty3:int = 0; enemyMeleeDifficulty3 < meleeEnemies; enemyMeleeDifficulty3++)
				{
					enemyMeleeProperties[enemyMeleeDifficulty3][1] = 9;
					enemyMeleeProperties[enemyMeleeDifficulty3][2] = 8;
					
				}
				for(var enemyRangeDifficulty3:int = 0; enemyRangeDifficulty3 < rangeEnemies; enemyRangeDifficulty3++)
				{
					enemyRangeProperties[enemyRangeDifficulty3][1] = 5;
					enemyRangeProperties[enemyRangeDifficulty3][2] = 8;
					enemyRangeProperties[enemyRangeDifficulty3][6] = 24;
				}
			}
			
			/*LOAD ALL BLOCKS FOR LEVEL*/
			
			/* ADD AND NAME MELEE ENEMIES */
			for (var spawnMeleeEnemies:int = 1; spawnMeleeEnemies <= meleeEnemies; spawnMeleeEnemies ++)
			{
				var enemyMelee:EnemyMelee = new EnemyMelee();
				
				if (difficulty == 1)
				{
					enemyMelee.gotoAndStop(1);
					enemyMelee.enemyMeleeEasy.gotoAndStop ("Walk");
				}
				else if (difficulty == 2)
				{
					enemyMelee.gotoAndStop(2);
					enemyMelee.enemyMeleeNormal.gotoAndStop ("Walk");
				}
				else if (difficulty == 3)
				{
					enemyMelee.gotoAndStop(3);
					enemyMelee.enemyMeleeHard.gotoAndStop ("Walk");
				}
				
				enemyMelee.name = "enemyMelee" + spawnMeleeEnemies;
				addChild(enemyMelee);
			}
			
			/* ADD AND NAME RANGED ENEMIES */
			for (var spawnRangeEnemies:int = 1; spawnRangeEnemies <= rangeEnemies; spawnRangeEnemies ++)
			{
				var enemyRange:EnemyRange = new EnemyRange();
				
				if (difficulty == 1)
				{
					enemyRange.gotoAndStop(1);
					enemyRange.enemyRangeEasy.gotoAndStop ("Walk");
				}
				else if (difficulty == 2)
				{
					enemyRange.gotoAndStop(2);
					enemyRange.enemyRangeNormal.gotoAndStop ("Walk");
				}
				else if (difficulty == 3)
				{
					enemyRange.gotoAndStop(3);
					enemyRange.enemyRangeHard.gotoAndStop ("Walk");
				}
				
				enemyRange.name = "enemyRange" + spawnRangeEnemies;
				addChild(enemyRange);
			}
			
			/* POSITION ALL ENEMIES*/
			if (me.target.name == "levelOne")
			{
				this.getChildByName("enemyMelee1").x = 2500;
				this.getChildByName("enemyMelee1").y = 400;
				
				this.getChildByName("enemyRange1").x = 2000;
				this.getChildByName("enemyRange1").y = 400;
				this.getChildByName("enemyRange1").scaleX = -1;
			}
			else if(me.target.name == "levelTwo")
			{
				this.getChildByName("enemyMelee1").x = 1900;
				this.getChildByName("enemyMelee1").y = 400;	
				
				this.getChildByName("enemyRange1").x = 1350;
				this.getChildByName("enemyRange1").y = 200;
				
				this.getChildByName("enemyRange2").x = 1075;
				this.getChildByName("enemyRange2").y = 300;
				
				this.getChildByName("enemyRange3").x = 400;
				this.getChildByName("enemyRange3").y = 400;
			}	
			else if(me.target.name == "levelThree")
			{
				this.getChildByName("enemyMelee1").x = 300;
				this.getChildByName("enemyMelee1").y = 400;	
				
				this.getChildByName("enemyMelee2").x = 1000;
				this.getChildByName("enemyMelee2").y = 400;	
				
				this.getChildByName("enemyMelee3").x = 1600;
				this.getChildByName("enemyMelee3").y = 400;	
				
				this.getChildByName("enemyMelee4").x = 2050;
				this.getChildByName("enemyMelee4").y = 400;
				
				this.getChildByName("enemyMelee5").x = 2300;
				this.getChildByName("enemyMelee5").y = 400;	
				
				this.getChildByName("enemyMelee6").x = 2750;
				this.getChildByName("enemyMelee6").y = 400;	
				
				this.getChildByName("enemyRange1").x = 1350;
				this.getChildByName("enemyRange1").y = 400;
				
				this.getChildByName("enemyRange2").x = 2050;
				this.getChildByName("enemyRange2").y = 400;
				
				this.getChildByName("enemyRange3").x = 2300;
				this.getChildByName("enemyRange3").y = 400;
				
				this.getChildByName("enemyRange4").x = 2800;
				this.getChildByName("enemyRange4").y = 400;
			}	
			else if(me.target.name == "levelFour")
			{
				this.getChildByName("enemyMelee1").x = 1650;
				this.getChildByName("enemyMelee1").y = 350;	
				
				this.getChildByName("enemyMelee2").x = 1900;
				this.getChildByName("enemyMelee2").y = 350;

				this.getChildByName("enemyRange1").x = 1125;
				this.getChildByName("enemyRange1").y = 300;
				
				this.getChildByName("enemyRange2").x = 425;
				this.getChildByName("enemyRange2").y = 400;
				
				this.getChildByName("enemyRange3").x = 425;
				this.getChildByName("enemyRange3").y = 200;
				
				this.getChildByName("enemyRange4").x = 1125;
				this.getChildByName("enemyRange4").y = 400;
				
				this.getChildByName("enemyRange5").x = 1125;
				this.getChildByName("enemyRange5").y = 200;
			}
			else if(me.target.name == "levelFive")
			{
				this.getChildByName("enemyMelee1").x = 1550;
				this.getChildByName("enemyMelee1").y = 400;	
				
				this.getChildByName("enemyMelee2").x = 1850;
				this.getChildByName("enemyMelee2").y = 400;
				
				this.getChildByName("enemyMelee3").x = 2000;
				this.getChildByName("enemyMelee3").y = 400;
				
				this.getChildByName("enemyMelee4").x = 2000;
				this.getChildByName("enemyMelee4").y = 400;

				this.getChildByName("enemyRange1").x = 1700;
				this.getChildByName("enemyRange1").y = 400;
				this.getChildByName("enemyRange1").scaleX = -1;
				
				this.getChildByName("enemyRange2").x = 1850;
				this.getChildByName("enemyRange2").y = 400;
				this.getChildByName("enemyRange2").scaleX = -1;
				
				this.getChildByName("enemyRange3").x = 2000;
				this.getChildByName("enemyRange3").y = 400;
				this.getChildByName("enemyRange3").scaleX = -1;
				
				this.getChildByName("enemyRange4").x = 2000;
				this.getChildByName("enemyRange4").y = 400;
				this.getChildByName("enemyRange4").scaleX = -1;
			}
			totalEnemies = rangeEnemies + meleeEnemies;
			
			level.x = 0;
			level.y = 0;

			mega.inertia = 12;
			mega.gotoAndStop("Idle");
			
			/* Health Text */
			healthFormat.font = ("Tw Cen MT Condensed");
			healthFormat.size = 55;
			healthFormat.color = 0x000000;
			healthFormat.align = 'left';
			
			
			healthText.defaultTextFormat = healthFormat;
			healthText.width = 300;
			healthText.x = 50;
			healthText.y = 50;
			allEnemiesDead = true;
			
			/* Add health bar for melees*/
			for(var addMeleeHealthBorder:int = 1; addMeleeHealthBorder <= meleeEnemies; addMeleeHealthBorder++)
			{
				var enemyMeleeHealthBorder:EnemyMeleeHealthBorder = new EnemyMeleeHealthBorder();
				var enemyMeleeHealthBar:EnemyMeleeHealthBar = new EnemyMeleeHealthBar();
				
				enemyMeleeHealthBorder.x = this.getChildByName("enemyMelee" + addMeleeHealthBorder).x
				enemyMeleeHealthBorder.y = this.getChildByName("enemyMelee" + addMeleeHealthBorder).y - this.getChildByName("enemyMelee" + addMeleeHealthBorder).height - 10;
				enemyMeleeHealthBorder.name = "enemyMeleeHealthBorder" + addMeleeHealthBorder;
				
				
				enemyMeleeHealthBar.x = enemyMeleeHealthBorder.x - (enemyMeleeHealthBorder.width/2) + 2;
				enemyMeleeHealthBar.y = enemyMeleeHealthBorder.y;
				enemyMeleeHealthBar.name = "enemyMeleeHealthBar" + addMeleeHealthBorder;
				
				addChild(enemyMeleeHealthBorder);
				addChild(enemyMeleeHealthBar);
			
			}
			/* Add health bar for ranges*/
			for(var addRangeHealthBorder:int = 1; addRangeHealthBorder <= rangeEnemies; addRangeHealthBorder++)
			{
				var enemyRangeHealthBorder:EnemyRangeHealthBorder = new EnemyRangeHealthBorder();
				var enemyRangeHealthBar:EnemyRangeHealthBar = new EnemyRangeHealthBar();
				
				enemyRangeHealthBorder.x = this.getChildByName("enemyRange" + addRangeHealthBorder).x
				enemyRangeHealthBorder.y = this.getChildByName("enemyRange" + addRangeHealthBorder).y - this.getChildByName("enemyRange" + addRangeHealthBorder).height - 10;
				enemyRangeHealthBorder.name = "enemyRangeHealthBorder" + addRangeHealthBorder;
				
				
				enemyRangeHealthBar.x = enemyRangeHealthBorder.x - (enemyRangeHealthBorder.width/2) + 2;
				enemyRangeHealthBar.y = enemyRangeHealthBorder.y;
				enemyRangeHealthBar.name = "enemyRangeHealthBar" + addRangeHealthBorder;
				
				addChild(enemyRangeHealthBorder);
				addChild(enemyRangeHealthBar);
			
			}
			trace(this.numChildren, "number of objects on the stage");
	
			addChild(mega);
			
			addChild(healthText);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keymega);
			stage.addEventListener(KeyboardEvent.KEY_UP, stopmega);
			stage.addEventListener(Event.ENTER_FRAME, gameAction);
			
		}
		
		public function keymega(ke:KeyboardEvent)
		{
			/* Take Controls */
			if (levelFinished == false)
			{
				if (ke.keyCode == Keyboard.RIGHT)
				{
					mega.scaleX= 1;
					mega.xSpeed = gameSpeed;
					running = true;
	
				}
				if (ke.keyCode == Keyboard.LEFT)
				{
					mega.scaleX = -1;
					mega.xSpeed = -gameSpeed;
					running = true;
					
				}
				if (ke.keyCode == Keyboard.UP)
				{
					if (!mega.jump)
					{
						mega.ySpeed=-mega.inertia;
						mega.jump=true;
						
					}
				}
				if (ke.keyCode == Keyboard.DOWN)
				{
					if (slideCount < 12)
					{
						sliding = true;
					}
				}	
				if (ke.keyCode == 88)
				{
					attacking = true;
					shooting = false;
					
				}
			}
		}
		
		public function gameAction(e:Event) 
		{
			/* SCREEN AND STAGE */
			var sand:Color = new Color();
			sand.setTint(0xFF9933, 0.5);
			
			var ice:Color = new Color();
			ice.setTint(0x00CCFF, 0.5);
			
			var white:Color = new Color();
			white.setTint(0xFFFFFF, 0.25);
			
			timeInLevel ++;
			// health info
			if (levelFinished == false)
			{
				healthText.text = "Health  " + megaHealth;
			}
			else 
			{
				healthText.text = "Health  " + 0;
			}
			
			// change block color based on property
			for(var colorBlocks:int = 0; colorBlocks < numOfABlocks; colorBlocks++)
			{
				
				if (blockAStates[colorBlocks][1] == "Normal")
				{
					
				}
				else if (blockAStates[colorBlocks][1] == "Sand")
				{
					level.getChildByName("blockA" + (colorBlocks+1) + selectedLevel).transform.colorTransform  = sand;
				}
				else if (blockAStates[colorBlocks][1] == "Ice")
				{
					level.getChildByName("blockA" + (colorBlocks+1) + selectedLevel).transform.colorTransform  = ice;
				}

			}
			
			// make scene white in order for clarity
			scene.transform.colorTransform = white;
			
			//move objects when reach end of screen
			if (currScreen != finalScreen)
			{
				if (mega.x > 750)
				{
					scene.x -= 200;
					level.x -= 700;

					mega.x = 50;
					for (var moveMeleeLeft:int = 1; moveMeleeLeft <= meleeEnemies; moveMeleeLeft++)
					{
						this.getChildByName("enemyMelee" + moveMeleeLeft).x -= 700;
					}
					
					for (var moveRangeLeft:int = 1; moveRangeLeft <= rangeEnemies; moveRangeLeft++)
					{
						this.getChildByName("enemyRange" + moveRangeLeft).x -= 700;
					}
					
					for (var moveEnemyBulletsLeft:int = 0;  moveEnemyBulletsLeft < enemyAmountShot; moveEnemyBulletsLeft ++)
					{
						this.getChildByName("enemyBullet" +  moveEnemyBulletsLeft).alpha = 0;
					}
					
					currScreen += 1;
					for (var stopMovingBulletsL:int = 0; stopMovingBulletsL< amountShot; stopMovingBulletsL ++)
					{
						this.getChildByName("bullet" + stopMovingBulletsL).alpha = 0;
						this.getChildByName("bullet" + stopMovingBulletsL).y = 0;
						shotDirection[stopMovingBulletsL] = 0;
					}
				
				
				
					for (var stopMovingEnemyBulletsL:int = 0; stopMovingEnemyBulletsL< enemyAmountShot; stopMovingEnemyBulletsL ++)
					{
						this.getChildByName("enemyBullet" + stopMovingEnemyBulletsL).alpha = 0;
						this.getChildByName("enemyBullet" + stopMovingEnemyBulletsL).y = 0;
						shotDirection[stopMovingEnemyBulletsL] = 0;
					}
				}
			}
			else
			{
				// if level beat 
				if (mega.x > 750)
				{
					mega.x = 749;
					if(totalEnemies == 0)
					{
						myChannel.stop();
						addChild(filter);
						addChild(winScreen);
						winScreen.x = 400;
						winScreen.y = 200;
						levelFinished = true;
						
						winScreen.backToMenuGame.addEventListener(MouseEvent.CLICK, backToMenu);
					}
				}
			}
			
			//move objects when reach begging of screen
			if (currScreen != 1)
			{
				if (mega.x < 50)
				{
					
					scene.x += 200;
					level.x += 700;
	
					mega.x = 750;
					
					for (var moveMeleeRight:int = 1; moveMeleeRight <= meleeEnemies; moveMeleeRight++)
					{
						this.getChildByName("enemyMelee" + moveMeleeRight).x += 700;
					}
					for (var moveRangeRight:int = 1; moveRangeRight <= rangeEnemies; moveRangeRight++)
					{
						this.getChildByName("enemyRange" + moveRangeRight).x += 700;
					}
					for (var moveEnemyBulletsRight:int = 0;  moveEnemyBulletsRight < enemyAmountShot; moveEnemyBulletsRight++)
					{
						this.getChildByName("enemyBullet" +  moveEnemyBulletsRight).alpha = 0;
					}
					
					currScreen -= 1;
					
					for (var stopMovingBulletsR:int = 0; stopMovingBulletsR< amountShot; stopMovingBulletsR ++)
					{
						this.getChildByName("bullet" + stopMovingBulletsR).alpha = 0;
						this.getChildByName("bullet" + stopMovingBulletsR).y = 0;
						shotDirection[stopMovingBulletsR] = 0;
					}
				
				
				
					for (var stopMovingEnemyBulletsR:int = 0; stopMovingEnemyBulletsR< enemyAmountShot; stopMovingEnemyBulletsR ++)
					{
						this.getChildByName("enemyBullet" + stopMovingEnemyBulletsR).alpha = 0;
						this.getChildByName("enemyBullet" + stopMovingEnemyBulletsR).y = 0;
						shotDirection[stopMovingEnemyBulletsR] = 0;
					}
				}
			}
			else
			{
				if (mega.x < mega.width/2)
				{
					mega.x = mega.width/2;
				}
			}
			/* Custom code specifically for arena level */
			if (selectedLevel == 5)
			{
				if(timeInLevel == 1)
				{
					level.getChildByName("blockB15").y = 225;
					level.getChildByName("blockB25").y = 250;
					level.getChildByName("blockB25").y = 250;
					level.getChildByName("blockB35").y = 250;
					level.getChildByName("blockB45").y = 250;
					level.getChildByName("blockB55").y = 250;
				}

				if(currScreen == 2 && mega.x > 55)
				{
					level.getChildByName("blockB15").y = 250;
				}
				
				if(timeInLevel == 240)
				{
					level.getChildByName("blockB25").y = 150;
				}
				else if(timeInLevel == 720)
				{
					blockAStates[2][1] = "Sand"; 
					level.getChildByName("blockB25").y = 150;
					level.getChildByName("blockB35").y = 150;
				}
				else if(timeInLevel == 1200)
				{
					blockAStates[1][1] = "Sand"; 
					blockAStates[3][1] = "Sand";
					
					level.getChildByName("blockB25").y = 150;
					level.getChildByName("blockB45").y = 150;
					
					this.getChildByName("enemyMelee2").x = 1550-700;
					this.getChildByName("enemyRange2").x = 1850-700;
				}
				else if(timeInLevel == 1920)
				{
					blockAStates[0][1] = "Sand"; 
					blockAStates[4][1] = "Sand";
					blockAStates[5][1] = "Sand";
					level.getChildByName("blockB25").y = 150;
					level.getChildByName("blockB55").y = 150;
					this.getChildByName("enemyMelee3").x = 1550-700;
					this.getChildByName("enemyRange4").x = 1700-700;
					this.getChildByName("enemyRange3").x = 1850-700;
					this.getChildByName("enemyMelee4").x = 2000-700;
				}
				
			
				if (difficulty == 1)
				{
					if(timeInLevel == 300 || timeInLevel == 850 || timeInLevel == 1400 || timeInLevel == 2200)
					{
						level.getChildByName("blockB25").y = 250;
					}
				}
				else if (difficulty == 2)
				{
					if(timeInLevel == 275 || timeInLevel == 800 || timeInLevel == 1325 || timeInLevel == 2140)
					{
						level.getChildByName("blockB25").y = 250;
					}
				}
				else if (difficulty == 3)
				{
					if(timeInLevel == 265 || timeInLevel == 780 || timeInLevel == 1295 || timeInLevel == 2100)
					{
						level.getChildByName("blockB25").y = 250;
					}
				}
				
				if (totalEnemies == 0)
				{
					level.getChildByName("blockB25").y = -150;
				}
			}
			if (amountShot > 0)
			{
				for (var k:int = 0; k < amountShot; k++)
				{
					if(this.getChildByName("bullet" + k).x > 800 || this.getChildByName("bullet" + k).x < 0)
					{
						this.getChildByName("bullet" + k).alpha = 0;
						this.getChildByName("bullet" + k).y = 0;
						shotDirection[i] = 0;
					}
				}
				
			}
			
			/* ENEMEY MOVEMENT AND ACTIONS */ 
			
			/* move and change health border */
			for(var moveMeleeHealthBorder:int = 1; moveMeleeHealthBorder <= meleeEnemies; moveMeleeHealthBorder++)
			{
				
				this.getChildByName("enemyMeleeHealthBorder" + moveMeleeHealthBorder).x = this.getChildByName("enemyMelee" + moveMeleeHealthBorder).x
				this.getChildByName("enemyMeleeHealthBorder" + moveMeleeHealthBorder).y = this.getChildByName("enemyMelee" + moveMeleeHealthBorder).y - 70;
				
				this.getChildByName("enemyMeleeHealthBar" + moveMeleeHealthBorder).x = this.getChildByName("enemyMeleeHealthBorder" + moveMeleeHealthBorder).x - (this.getChildByName("enemyMeleeHealthBorder" + moveMeleeHealthBorder).width/2) + 2;
				this.getChildByName("enemyMeleeHealthBar" + moveMeleeHealthBorder).y = this.getChildByName("enemyMeleeHealthBorder" + moveMeleeHealthBorder).y;
				this.getChildByName("enemyMeleeHealthBar" + moveMeleeHealthBorder).width =  enemyMeleeProperties[moveMeleeHealthBorder - 1][2]/enemyMaxHealth*30;
				if(enemyMeleeProperties[moveMeleeHealthBorder - 1][2] == 0)
				{
					this.getChildByName("enemyMeleeHealthBar" + moveMeleeHealthBorder).alpha = 0;
					this.getChildByName("enemyMeleeHealthBorder" + moveMeleeHealthBorder).alpha = 0;
				}
			}
			for(var moveRangeHealthBorder:int = 1; moveRangeHealthBorder <= rangeEnemies; moveRangeHealthBorder++)
			{
				
				this.getChildByName("enemyRangeHealthBorder" + moveRangeHealthBorder).x = this.getChildByName("enemyRange" + moveRangeHealthBorder).x
				this.getChildByName("enemyRangeHealthBorder" + moveRangeHealthBorder).y = this.getChildByName("enemyRange" + moveRangeHealthBorder).y - 70;
				
				this.getChildByName("enemyRangeHealthBar" + moveRangeHealthBorder).x = this.getChildByName("enemyRangeHealthBorder" + moveRangeHealthBorder).x - (this.getChildByName("enemyRangeHealthBorder" + moveRangeHealthBorder).width/2) + 2;
				this.getChildByName("enemyRangeHealthBar" + moveRangeHealthBorder).y = this.getChildByName("enemyRangeHealthBorder" + moveRangeHealthBorder).y;
				this.getChildByName("enemyRangeHealthBar" + moveRangeHealthBorder).width =  enemyRangeProperties[moveRangeHealthBorder - 1][2]/enemyMaxHealth*30;
				if(enemyRangeProperties[moveRangeHealthBorder - 1][2] == 0)
				{
					this.getChildByName("enemyRangeHealthBar" + moveRangeHealthBorder).alpha = 0;
					this.getChildByName("enemyRangeHealthBorder" + moveRangeHealthBorder).alpha = 0;
				}
			}
			
			/* check for enmy getting shot and enemy shooting player */
			for(var enemyMeleeActions:int = 1; enemyMeleeActions <= meleeEnemies; enemyMeleeActions ++)
			{
				if (enemyMeleeProperties[enemyMeleeActions - 1][3] == 1 && levelFinished == false)
				{
					this.getChildByName("enemyMelee" + enemyMeleeActions).x -= enemyMeleeProperties[enemyMeleeActions - 1][1];
					this.getChildByName("enemyMelee" + enemyMeleeActions).alpha = 1;
					
					if (enemyMeleeProperties[enemyMeleeActions - 1][2] == 0)
					{
						this.getChildByName("enemyMelee" + enemyMeleeActions).alpha = 0;						
						enemyMeleeProperties[enemyMeleeActions - 1][3] = 0;
						
					}
					
					if (this.getChildByName("enemyMelee" + enemyMeleeActions).hitTestObject(mega) && megaInvincible == false && levelFinished == false)
					{
						if (difficulty == 1)
						{
							megaHealth -= 2;
						}
						else if (difficulty == 2)
						{
							megaHealth -= 3
						}
						else if (difficulty == 3)
						{
							megaHealth -= 5
						}
						
						megaInvincible = true;
						
					}
				}
			}
		
			// make player invincible for small amount of time
			if (megaInvincible == true)
			{
				if (invincibleTime == 1)
				{
					megaHit.play();
				}
				mega.alpha = 0.65;
				invincibleTime ++;
				if (invincibleTime == timeToRegen)
				{
					megaInvincible = false;
					invincibleTime = 0;
				}
			}
			else 
			{
				mega.alpha = 1.0
			}
			
			/* range enmy actions including shooting and getting shot */
			for(var enemyRangeActions:int = 1; enemyRangeActions <= rangeEnemies; enemyRangeActions ++)
			{
				if (enemyRangeProperties[enemyRangeActions - 1][3] == 1 && levelFinished == false)
				{
					if (enemyRangeProperties[enemyRangeActions - 1][7] == 1)
					{ 
						this.getChildByName("enemyRange" + enemyRangeActions).x -= enemyRangeProperties[enemyRangeActions - 1][1];
					}
					else
					{
						if(mega.x < this.getChildByName("enemyRange" + enemyRangeActions).x)
						{
							this.getChildByName("enemyRange" + enemyRangeActions).scaleX = -1;
						}
						else if(mega.x > this.getChildByName("enemyRange" + enemyRangeActions).x)
						{
							this.getChildByName("enemyRange" + enemyRangeActions).scaleX = 1;
						}
					}
					
					this.getChildByName("enemyRange" + enemyRangeActions).alpha = 1;
					if (enemyRangeProperties[enemyRangeActions - 1][2] == 0)
					{
						this.getChildByName("enemyRange" + enemyRangeActions).alpha = 0;						
						enemyRangeProperties[enemyRangeActions - 1][3] = 0;
					}
					
					if (enemyRangeProperties[enemyRangeActions - 1][8] == 1)
					{
						var enemyBullet:EnemyBullet = new EnemyBullet;
						
						enemyBullet.scaleX = this.getChildByName("enemyRange" + enemyRangeActions).scaleX;
						enemyBullet.x = this.getChildByName("enemyRange" + enemyRangeActions).x + (20 * this.getChildByName("enemyRange" + enemyRangeActions).scaleX);
						enemyBullet.y = this.getChildByName("enemyRange" + enemyRangeActions).y - (this.getChildByName("enemyRange" + enemyRangeActions).height/2);
						if(enemyBullet.x < 800 && enemyBullet.x > 0)
						{
							enemyShoot.play();
						}
						addChild(enemyBullet);
						enemyBullet.name = "enemyBullet" + enemyAmountShot;
						enemyShotDirection[enemyAmountShot] = this.getChildByName("enemyRange" + enemyRangeActions).scaleX;
						enemyAmountShot ++;
						enemyRangeProperties[enemyRangeActions - 1][8] = 0;
						enemyRangeProperties[enemyRangeActions - 1][5] = 0;
					}
					if (enemyRangeProperties[enemyRangeActions - 1][8] == 0)
					{
						enemyRangeProperties[enemyRangeActions - 1][5]++;
						
						if (enemyRangeProperties[enemyRangeActions - 1][5] == enemyRangeProperties[enemyRangeActions - 1][6])
						{
							enemyRangeProperties[enemyRangeActions - 1][8] = 1;
						}
					}
					
				}
			}
			if (enemyAmountShot > 0 && levelFinished == false)
			{
				for (var enemyBullets:int = 0; enemyBullets < enemyAmountShot; enemyBullets++)
				{
					this.getChildByName("enemyBullet" + enemyBullets).x += 7 * enemyShotDirection[enemyBullets];
					
					if ((mega).hitTestObject(this.getChildByName("enemyBullet" + enemyBullets)) && megaInvincible == false && levelFinished == false)
					{
						this.getChildByName("enemyBullet" + enemyBullets).alpha = 0;
						this.getChildByName("enemyBullet" + enemyBullets).y = 0;
						enemyShotDirection[enemyBullets] = 0;
						
						if (difficulty == 1)
						{
							megaHealth -= 1;
						}
						else if (difficulty == 2)
						{
							megaHealth -= 2;
						}
						else if (difficulty == 3)
						{
							megaHealth -= 3;
						}
						
						megaInvincible = true;
						
						

					}
					
					for (var enemyBulletABlock:int = 1; enemyBulletABlock <= numOfABlocks; enemyBulletABlock++)
					{
						if (level.getChildByName("blockA" + enemyBulletABlock + selectedLevel).hitTestObject(this.getChildByName("enemyBullet" + enemyBullets)) == true)
						{
							this.getChildByName("enemyBullet" + enemyBullets).alpha = 0;
							this.getChildByName("enemyBullet" + enemyBullets).y = 0;
							enemyShotDirection[enemyBulletABlock] = 0;
						}
					}
					
					for (var enemyBulletBBlock:int = 1; enemyBulletBBlock <= numOfBBlocks; enemyBulletBBlock++)
					{
						if (level.getChildByName("blockB" + enemyBulletBBlock + selectedLevel).hitTestObject(this.getChildByName("enemyBullet" + enemyBullets)) == true)
						{
							this.getChildByName("enemyBullet" + enemyBullets).alpha = 0;
							this.getChildByName("enemyBullet" + enemyBullets).y = 0;
							enemyShotDirection[enemyBulletBBlock] = 0;
						}
					}
					
					if ((this.getChildByName("enemyBullet" + enemyBullets).x > 800) || (this.getChildByName("enemyBullet" + enemyBullets).x < 0))
					{
						this.getChildByName("enemyBullet" + enemyBullets).alpha = 0;
						this.getChildByName("enemyBullet" + enemyBullets).y = 0;
						enemyShotDirection[enemyBullets] = 0;
					}
					
					if (enemyShotDirection[enemyBullets] == 0)
					{
						this.getChildByName("enemyBullet" + enemyBullets).alpha = 0;
						this.getChildByName("enemyBullet" + enemyBullets).y = 0;
					}
					
				}
			}
			
			
			
			/* PLAYER MOVEMENT AND ACTIONS */
		
			/* fail state*/
			if (megaHealth <= 0 && levelFinished == false)
			{
				myChannel.stop();
				megaDeath.play();
				addChild(filter);
				addChild(gameOver);
				gameOver.x = 400;
				gameOver.y = 200;
				levelFinished = true;
				megaHealth = 1;
				
				gameOver.backToMenuGameOver.addEventListener(MouseEvent.CLICK, backToMenu);
			}
			
			if (levelFinished == false)
			{
				mega.x+= mega.xSpeed * slowMultiplier;
				mega.ySpeed += gravity;
				mega.y+=mega.ySpeed;
			}
			
			var bullet:megaBullet = new megaBullet();

	
			
			if (mega.y > 600)
			{
				mega.x = 50;
				mega.y = 400;
			}
			
			/* player animations */
			if (mega.ySpeed < 0.8 && attacking == false && shooting == false )
			{
				mega.gotoAndStop("Jump");
				mega.jump = true;
			}
			else if (mega.ySpeed > 0.8 && attacking == false && shooting == false)
			{
				mega.gotoAndStop("Fall");
				mega.jump = true;
			}
			
			if (running == false && mega.ySpeed == 0.8 && attacking == false && shooting == false) 
			{
				mega.gotoAndStop("Idle");
			}
			
			if (running == true && mega.ySpeed == 0.8 && sliding == false && attacking == false && shooting == false) 
			{
				mega.gotoAndStop("Run");
			}
			
			if (canShoot == false)
			{
				timeToShoot ++;
				
				if (timeToShoot == shootReload)
				{
					canShoot = true;
				}
			}
			
			/* if shooting add bullets and position bullets based on state*/
			if (shooting == true && sliding == false)
			{
				if (canShoot == true)
				{
					addChild(bullet);
					bullet.name = "bullet" + amountShot;
					shotDirection[amountShot] = mega.scaleX;
					amountShot ++;
					canShoot = false;
					timeToShoot = 0;
					megaShoot.play();
				}
				
				if (running == false && mega.ySpeed == 0.8)
				{
					mega.gotoAndStop("IdleShoot");
					
					bullet.x = mega.x;
					bullet.y = mega.y - 23;
				}
				else if (running == true && mega.ySpeed == 0.8)
				{
					mega.gotoAndStop("RunShoot");

					bullet.x = mega.x;
					bullet.y = mega.y - 22;
				}
				else
				{
					mega.gotoAndStop("JumpShoot");

					bullet.x = mega.x;
					bullet.y = mega.y - 33;
				}
			}
			if (levelFinished == true)
			{
				for (var stopMovingBullets:int = 0; stopMovingBullets< amountShot; stopMovingBullets ++)
				{
					this.getChildByName("bullet" + stopMovingBullets).alpha = 0;
					this.getChildByName("bullet" + stopMovingBullets).y = 0;
					shotDirection[stopMovingBullets] = 0;
				}
			}
			
			if (levelFinished == true)
			{
				for (var stopMovingEnemyBullets:int = 0; stopMovingEnemyBullets< enemyAmountShot; stopMovingEnemyBullets ++)
				{
					this.getChildByName("enemyBullet" + stopMovingEnemyBullets).alpha = 0;
					this.getChildByName("enemyBullet" + stopMovingEnemyBullets).y = 0;
					shotDirection[stopMovingEnemyBullets] = 0;
				}
			}
			
			/* move bullets and apply collision*/
			if (amountShot > 0)
			{
				for (var i:int = 0; i < amountShot; i++)
				{
					this.getChildByName("bullet" + i).x += 16 * shotDirection[i];
					
					for (var enemyMeleeBulletHit:int = 1; enemyMeleeBulletHit <= meleeEnemies; enemyMeleeBulletHit++)
					{
						if (enemyMeleeProperties[enemyMeleeBulletHit - 1][3] == 1)
						{
							if ((this.getChildByName("enemyMelee" + enemyMeleeBulletHit)).hitTestObject(this.getChildByName("bullet" + i)))
							{
								enemyMeleeProperties[enemyMeleeBulletHit - 1][2] -= 1;
								this.getChildByName("bullet" + i).alpha = 0;
								this.getChildByName("bullet" + i).y = 0;
								shotDirection[i] = 0;
								enemyHit.play();
								if (enemyMeleeProperties[enemyMeleeBulletHit - 1][2] == 0)
								{
									totalEnemies -= 1;
								}
	
							}
						}					
					}
					
					for (var enemyRangeBulletHit:int = 1; enemyRangeBulletHit <= rangeEnemies; enemyRangeBulletHit++)
					{
						if (enemyRangeProperties[enemyRangeBulletHit - 1][3] == 1)
						{
							if ((this.getChildByName("enemyRange" + enemyRangeBulletHit)).hitTestObject(this.getChildByName("bullet" + i)))
							{
								enemyRangeProperties[enemyRangeBulletHit - 1][2] -= 1;
								this.getChildByName("bullet" + i).alpha = 0;
								this.getChildByName("bullet" + i).y = 0;
								shotDirection[i] = 0;
								enemyHit.play();
								if (enemyRangeProperties[enemyRangeBulletHit - 1][2] == 0)
								{
									totalEnemies -= 1;
								}
	
							}
						}					
					}
					
					for (var bulletABlock:int = 1; bulletABlock <= numOfABlocks; bulletABlock++)
					{
						if (level.getChildByName("blockA" + bulletABlock + selectedLevel).hitTestObject(this.getChildByName("bullet" + i)) == true)
						{
							this.getChildByName("bullet" + i).alpha = 0;
							this.getChildByName("bullet" + i).y = 0;
							shotDirection[i] = 0;
						}
					}
					for (var bulletBBlock:int = 1; bulletBBlock <= numOfBBlocks; bulletBBlock++)
					{
						if (level.getChildByName("blockB" + bulletBBlock + selectedLevel).hitTestObject(this.getChildByName("bullet" + i)) == true)
						{
							this.getChildByName("bullet" + i).alpha = 0;
							this.getChildByName("bullet" + i).y = 0;
							shotDirection[i] = 0;
						}
					}
					
					if ((this.getChildByName("bullet" + i).x > 800) || (this.getChildByName("bullet" + i).x < 0))
					{
						this.getChildByName("bullet" + i).alpha = 0;
						this.getChildByName("bullet" + i).y = 0;
						shotDirection[i] = 0;
					}

				}
			}

			if (attacking == true)
			{
				if (mega.ySpeed == 0.8)
				{
					mega.gotoAndStop("GroundAttack");
				}
				else
				{
					mega.gotoAndStop("JumpAttack");
				}
			}
			
			if (mega.xSpeed != 0 && sliding == true && mega.ySpeed == 0.8)
			{
				if (slideCount < 18)
				{
					mega.gotoAndStop("Slide");
					
					sliding = true;
					slideCount ++;
				}
				else 
				{
					sliding = false;
					
				}
				if (slideCount == 1)
				{
					megaSlide.play();
				}
			} 
			
			/* GROUND */
			
			/* ground collision*/
			if (level.ground1.hitTestPoint(mega.x-mega.width/2, mega.y, true) || level.ground1.hitTestPoint(mega.x+mega.width/2, mega.y, true))
			{
				mega.ySpeed = 0;
				mega.y = level.ground1.y;
				mega.jump = false;
				slowMultiplier = normalSpeed;
			}
			if (level.ground1.hitTestPoint((mega.x-mega.width/2 - 20), (mega.y - mega.height / 3), true) || level.ground1.hitTestPoint((mega.x-mega.width/2 - 20), (mega.y - mega.height * 2/3), true))
			{
				mega.x = level.ground1.x + level.ground1.width + 40 - (700 * (currScreen - 1));	
			}
			else if (level.ground1.hitTestPoint((mega.x+mega.width/2 + 20), (mega.y - mega.height / 3), true) || level.ground1.hitTestPoint((mega.x+mega.width/2 + 20), (mega.y - mega.height *  2/3), true))
			{
				mega.x = level.ground1.x - 40 - (700 * (currScreen - 1));
			}
			
			if (selectedLevel == 1)
			{
				if (level.ground2.hitTestPoint(mega.x-mega.width/2, mega.y, true) || level.ground2.hitTestPoint(mega.x+mega.width/2 - 20, mega.y, true))
				{
					mega.ySpeed = 0;
					mega.y = level.ground2.y;
					mega.jump = false;
					slowMultiplier = normalSpeed;
				}
				if (level.ground2.hitTestPoint((mega.x-mega.width/2 - 20), (mega.y - mega.height / 3), true) || level.ground2.hitTestPoint((mega.x-mega.width/2 + 20), (mega.y - mega.height * 2/3), true))
				{
					mega.x = level.ground2.x + level.ground2.width + 40 - (700 * (currScreen - 1));
				}
				else if (level.ground2.hitTestPoint((mega.x+mega.width/2 + 20), (mega.y - mega.height / 3), true) || level.ground2.hitTestPoint((mega.x+mega.width/2), (mega.y - mega.height *  2/3), true))
				{
					mega.x = level.ground2.x - 40 - (700 * (currScreen - 1));

				}
			}
			
			
			/* BLOCK COLLISION  & MOVING */
			
			/* block collision for mega and enemy */
			for (var blockACollision:int = 1; blockACollision <= numOfABlocks; blockACollision++)
			{
				
				if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((mega.x-mega.width/2), (mega.y - mega.height / 3), true) || level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((mega.x-mega.width/2), (mega.y - mega.height * 2/3), true))
				{
					mega.x = level.getChildByName("blockA" + blockACollision + selectedLevel).x + level.getChildByName("blockA" + blockACollision + selectedLevel).width + 19 - (700 * (currScreen - 1));
				}
				else if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((mega.x+mega.width/2), (mega.y - mega.height / 3), true) || level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((mega.x+mega.width/2), (mega.y - mega.height *  2/3), true))
				{
					mega.x = level.getChildByName("blockA" + blockACollision + selectedLevel).x - 20 - (700 * (currScreen - 1));
				}
				else if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint(mega.x-mega.width/2, mega.y, true) || level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint(mega.x+mega.width/2, mega.y, true))
				{
					mega.ySpeed = 0;
					mega.y = level.getChildByName("blockA" + blockACollision + selectedLevel).y;
					mega.jump = false;
					
					if (blockAStates[blockACollision - 1][1] == "Normal")
					{
						 slowMultiplier = normalSpeed;
					}
					else if (blockAStates[blockACollision - 1][1] == "Sand")
					{
						 slowMultiplier = slowSpeed;
					}
					else if (blockAStates[blockACollision - 1][1] == "Ice")
					{
						slowMultiplier = fastSpeed;
					}
					
					if (blockAStates[blockACollision - 1][0] == "Vertical")
					{
						mega.y -= 6 * blockAStates[ blockACollision-1][3] * blockAStates[blockACollision-1][4];
					}
					else if
					(blockAStates[blockACollision - 1][0] == "Horizantel")
					{
						mega.x += 6 * blockAStates[blockACollision-1][3] * blockAStates[blockACollision-1][4];
					}
				}
				else if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint(mega.x-mega.width/2, mega.y - mega.height , true) || level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint(mega.x+mega.width/2, mega.y  - mega.height, true))
				{
					mega.ySpeed = 0;
					mega.y = level.getChildByName("blockA" + blockACollision + selectedLevel).y + level.getChildByName("blockA" + blockACollision + selectedLevel).height + mega.height;
				}
				
				for (var meleeEnemyCollisionA:int = 1; meleeEnemyCollisionA <= meleeEnemies; meleeEnemyCollisionA++)
				{
					
					if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((this.getChildByName("enemyMelee" + meleeEnemyCollisionA).x + enemyMelee.width/2 + 20), (this.getChildByName("enemyMelee" + meleeEnemyCollisionA).y - enemyMelee.height/3), true) && enemyMeleeProperties[meleeEnemyCollisionA - 1][4] == -1)
					{
						this.getChildByName("enemyMelee" + meleeEnemyCollisionA).scaleX *= -1;
						enemyMeleeProperties[meleeEnemyCollisionA - 1][1] *= -1;
						enemyMeleeProperties[meleeEnemyCollisionA - 1][4] *= -1;
					}
					else if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((this.getChildByName("enemyMelee" + meleeEnemyCollisionA).x - enemyMelee.width/2 - 20), (this.getChildByName("enemyMelee" + meleeEnemyCollisionA).y - enemyMelee.height/3), true) && enemyMeleeProperties[meleeEnemyCollisionA - 1][4] == 1)
					{
						this.getChildByName("enemyMelee" + meleeEnemyCollisionA).scaleX *= -1;
						enemyMeleeProperties[meleeEnemyCollisionA - 1][1] *= -1;
						enemyMeleeProperties[meleeEnemyCollisionA - 1][4] *= -1;
					}
					
					
				}
				
				for (var rangeEnemyCollisionA:int = 1; rangeEnemyCollisionA <= rangeEnemies; rangeEnemyCollisionA++)
				{

					if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((this.getChildByName("enemyRange" + rangeEnemyCollisionA).x + enemyRange.width/2 + 20), (this.getChildByName("enemyRange" + rangeEnemyCollisionA).y - enemyRange.height/3), true) && enemyRangeProperties[rangeEnemyCollisionA - 1][4] == -1)
					{
						this.getChildByName("enemyRange" + rangeEnemyCollisionA).scaleX *= -1;
						enemyRangeProperties[rangeEnemyCollisionA - 1][1] *= -1;
						enemyRangeProperties[rangeEnemyCollisionA - 1][4] *= -1;
					}
					else if (level.getChildByName("blockA" + blockACollision + selectedLevel).hitTestPoint((this.getChildByName("enemyRange" + rangeEnemyCollisionA).x - enemyRange.width/2 - 20), (this.getChildByName("enemyRange" + rangeEnemyCollisionA).y - enemyRange.height/3), true) && enemyRangeProperties[rangeEnemyCollisionA - 1][4] == 1)
					{
						this.getChildByName("enemyRange" + rangeEnemyCollisionA).scaleX *= -1;
						enemyRangeProperties[rangeEnemyCollisionA - 1][1] *= -1;
						enemyRangeProperties[rangeEnemyCollisionA - 1][4] *= -1;
					}
				}
				
				if (blockAStates[blockACollision-1][0] == "Vertical")
				{
					blockAStates[blockACollision-1][2] += 1;
					level.getChildByName("blockA" + blockACollision + selectedLevel).y -= 6 * blockAStates[blockACollision-1][3] * blockAStates[blockACollision-1][4];
					
					if (blockAStates[blockACollision-1][2] == 34)
					{
						blockAStates[blockACollision-1][3] *= -1;
						blockAStates[blockACollision-1][2] = 0;
					}
					
				}
				
				if (blockAStates[blockACollision-1][0] == "Horizantel")
				{
					blockAStates[blockACollision-1][2] += 1;
					level.getChildByName("blockA" +  blockACollision + selectedLevel).x += 6 * blockAStates[blockACollision-1][3]  * blockAStates[blockACollision-1][4];
	
					if (blockAStates[blockACollision-1][2] == 34)
					{
						blockAStates[blockACollision-1][3] *= -1;
						blockAStates[blockACollision-1][2] = 0;
					}
					
				}
				
				
			}
			for (var blockBCollision:int = 1; blockBCollision <= numOfBBlocks; blockBCollision++)
			{
				
				if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((mega.x-mega.width/2), (mega.y - mega.height / 4), true) || level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((mega.x-mega.width/2), (mega.y - mega.height * 3/4), true))
				{
					mega.x = level.getChildByName("blockB" + blockBCollision + selectedLevel).x + level.getChildByName("blockB" + blockBCollision + selectedLevel).width + 19  - (700 * (currScreen - 1));
				}
				else if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((mega.x+mega.width/2), (mega.y - mega.height / 4), true) || level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((mega.x+mega.width/2), (mega.y - mega.height *  3/4), true))
				{
					mega.x = level.getChildByName("blockB" + blockBCollision + selectedLevel).x - 20 - (700 * (currScreen - 1));
				}
				else if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint(mega.x-mega.width/2, mega.y, true) || level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint(mega.x+mega.width/2, mega.y, true))
				{
					mega.ySpeed = 0;
					mega.y = level.getChildByName("blockB" + blockBCollision + selectedLevel).y;
					mega.jump = false;
				}
				else if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint(mega.x-mega.width/2, mega.y - mega.height , true) || level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint(mega.x+mega.width/2, mega.y  - mega.height, true))
				{
					mega.ySpeed = 0;
					mega.y = level.getChildByName("blockB" + blockBCollision + selectedLevel).y + level.getChildByName("blockB" + blockBCollision + selectedLevel).height + mega.height;
				}
				
				for (var meleeEnemyCollisionB:int = 1; meleeEnemyCollisionB <= meleeEnemies; meleeEnemyCollisionB++)
				{
					
					if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((this.getChildByName("enemyMelee" + meleeEnemyCollisionB).x + enemyMelee.width/2 + 20), (this.getChildByName("enemyMelee" + meleeEnemyCollisionB).y - enemyMelee.height * 3/4), true) && enemyMeleeProperties[meleeEnemyCollisionB - 1][4] == -1)
					{
						this.getChildByName("enemyMelee" + meleeEnemyCollisionB).scaleX *= -1;
						enemyMeleeProperties[meleeEnemyCollisionB - 1][1] *= -1;
						enemyMeleeProperties[meleeEnemyCollisionB - 1][4] *= -1;
					}
					else if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((this.getChildByName("enemyMelee" + meleeEnemyCollisionB).x - enemyMelee.width/2 - 20), (this.getChildByName("enemyMelee" + meleeEnemyCollisionB).y - enemyMelee.height * 3/4), true) && enemyMeleeProperties[meleeEnemyCollisionB - 1][4] == 1)
					{
						this.getChildByName("enemyMelee" + meleeEnemyCollisionB).scaleX *= -1;
						enemyMeleeProperties[meleeEnemyCollisionB - 1][1] *= -1;
						enemyMeleeProperties[meleeEnemyCollisionB - 1][4] *= -1;
					}
				}
				
				for (var rangeEnemyCollisionB:int = 1; rangeEnemyCollisionB <= rangeEnemies; rangeEnemyCollisionB++)
				{

					if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((this.getChildByName("enemyRange" + rangeEnemyCollisionB).x + enemyRange.width/2 + 20), (this.getChildByName("enemyRange" + rangeEnemyCollisionB).y - enemyRange.height/3), true) && enemyRangeProperties[rangeEnemyCollisionB - 1][4] == -1)
					{
						this.getChildByName("enemyRange" + rangeEnemyCollisionB).scaleX *= -1;
						enemyRangeProperties[rangeEnemyCollisionB - 1][1] *= -1;
						enemyRangeProperties[rangeEnemyCollisionB - 1][4] *= -1;
					}
					else if (level.getChildByName("blockB" + blockBCollision + selectedLevel).hitTestPoint((this.getChildByName("enemyRange" + rangeEnemyCollisionB).x - enemyRange.width/2 - 20), (this.getChildByName("enemyRange" + rangeEnemyCollisionB).y - enemyRange.height/3), true) && enemyRangeProperties[rangeEnemyCollisionB - 1][4] == 1)
					{
						this.getChildByName("enemyRange" + rangeEnemyCollisionB).scaleX *= -1;
						enemyRangeProperties[rangeEnemyCollisionB - 1][1] *= -1;
						enemyRangeProperties[rangeEnemyCollisionB - 1][4] *= -1;
					}
				}
				
			}
			
			
	
		}		
		
		public function stopmega(ke:KeyboardEvent)
		{
			
			if (ke.keyCode == Keyboard.RIGHT)
			{
				mega.xSpeed=0;
				running = false;
			}
			if (ke.keyCode == Keyboard.LEFT)
			{
				mega.xSpeed=0;
				running = false;
			}
			if (ke.keyCode == Keyboard.DOWN)
			{
				sliding = false;
				slideCount = 0;
			}
			if (ke.keyCode != Keyboard.UP)
			{
				mega.gotoAndStop("Idle");
			}
			if (ke.keyCode == 88)
			{
				attacking = false;
			}
			if (ke.keyCode == 90)
			{
				shooting = false;
			}
			
		}
		
		public function backToMenu (me:MouseEvent)
		{
			if (me.target.name == "backToMenuPlay")
			{
				removeChild(playMenu);
				addChild(menu);
			}
			else if (me.target.name == "backToMenuHelp")
			{
				removeChild(helpMenu);
				addChild(menu);
			}
			else if (me.target.name == "backToMenuGame")
			{
				/* remove everything off screen when level complete */
				removeChild(healthText);
				removeChild(filter);
				removeChild(winScreen);
				removeChild(level);
				removeChild(scene);
				removeChild(mega);
				
				for (var removeMeleeEnemies:int = 1; removeMeleeEnemies <= meleeEnemies; removeMeleeEnemies ++)
				{
					removeChild(this.getChildByName("enemyMelee" + removeMeleeEnemies));

				}
				for (var removeRangeEnemies:int = 1; removeRangeEnemies <= rangeEnemies; removeRangeEnemies ++)
				{
					removeChild(this.getChildByName("enemyRange" + removeRangeEnemies));

				}
				for(var removeMeleeHealthBorder:int = 1; removeMeleeHealthBorder <= meleeEnemies; removeMeleeHealthBorder++)
				{
					
					removeChild(this.getChildByName("enemyMeleeHealthBorder" + removeMeleeHealthBorder));
					removeChild(this.getChildByName("enemyMeleeHealthBar" + removeMeleeHealthBorder));
					
				}
				for(var removeRangeHealthBorder:int = 1; removeRangeHealthBorder <= rangeEnemies; removeRangeHealthBorder++)
				{
					
					removeChild(this.getChildByName("enemyRangeHealthBorder" + removeRangeHealthBorder));
					removeChild(this.getChildByName("enemyRangeHealthBar" + removeRangeHealthBorder));
					
				}
				meleeEnemies = 0;
				rangeEnemies = 0;
				levelFinished = false;
				
				for (var stopMovingBullets:int = 0; stopMovingBullets< amountShot; stopMovingBullets ++)
				{
					removeChild(this.getChildByName("bullet" + stopMovingBullets));
				}
				for (var stopMovingEnemyBullets:int = 0; stopMovingEnemyBullets< enemyAmountShot; stopMovingEnemyBullets ++)
				{
					removeChild(this.getChildByName("enemyBullet" + stopMovingEnemyBullets));
				}
				amountShot = 0;
				enemyAmountShot = 0;
				
				
			}
			else if (me.target.name == "backToMenuGameOver")
			{
				/* remove everything off screen when death */
				removeChild(healthText);
				removeChild(filter);
				removeChild(gameOver);
				removeChild(level);
				removeChild(scene);
				removeChild(mega);
				
				for (var removeMeleeEnemiesGO:int = 1; removeMeleeEnemiesGO <= meleeEnemies; removeMeleeEnemiesGO ++)
				{
					removeChild(this.getChildByName("enemyMelee" + removeMeleeEnemiesGO));

				}
				for (var removeRangeEnemiesGO:int = 1; removeRangeEnemiesGO <= rangeEnemies; removeRangeEnemiesGO ++)
				{
					removeChild(this.getChildByName("enemyRange" + removeRangeEnemiesGO));

				}
				for(var removeMeleeHealthBorderGO:int = 1; removeMeleeHealthBorderGO <= meleeEnemies; removeMeleeHealthBorderGO++)
				{
					
					removeChild(this.getChildByName("enemyMeleeHealthBorder" + removeMeleeHealthBorderGO));					
					removeChild(this.getChildByName("enemyMeleeHealthBar" + removeMeleeHealthBorderGO));
					
				}
				for(var removeRangeHealthBorderGO:int = 1; removeRangeHealthBorderGO <= rangeEnemies; removeRangeHealthBorderGO++)
				{
					
					removeChild(this.getChildByName("enemyRangeHealthBorder" + removeRangeHealthBorderGO));					
					removeChild(this.getChildByName("enemyRangeHealthBar" + removeRangeHealthBorderGO));
					
				}
				meleeEnemies = 0;
				rangeEnemies = 0;
				levelFinished = false;
				
				for (var stopMovingBulletsGO:int = 0; stopMovingBulletsGO< amountShot; stopMovingBulletsGO ++)
				{
					removeChild(this.getChildByName("bullet" + stopMovingBulletsGO));
				}
				for (var stopMovingEnemyBulletsGO:int = 0; stopMovingEnemyBulletsGO< enemyAmountShot; stopMovingEnemyBulletsGO ++)
				{
					removeChild(this.getChildByName("enemyBullet" + stopMovingEnemyBulletsGO));
				}
				
				amountShot = 0;
				enemyAmountShot = 0;

			}
		}
	}

}
