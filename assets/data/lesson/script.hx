package assets.data.lesson;

import funkin.Constants;

import flixel.addons.transition.FlxTransitionableState;

import funkin.states.PlayState;
import funkin.backend.ClientPrefs;

import flixel.sound.FlxSound;
import flixel.FlxG;

import funkin.scripting.HScript;

import flixel.util.FlxTimer;

import funkin.backend.Paths;

import animate.FlxAnimate;

import flixel.graphics.atlas.FlxAtlas;

import funkin.backend.MathResolver;
import funkin.backend.Conductor;
import funkin.utils.CoolUtil;

import flixel.FlxCamera;

import funkin.objects.AttachedSprite;
import funkin.utils.RandomUtil;

import flixel.FlxSprite;

function onCreate()
{
	trace('onCreate: [INICIO]');
	Story.mathMisses = 0;
	trace('onCreate: mathMisses resetado para 0');
	
	trace('onCreate: chamando initScript...');
	initScript('scripts/thinkpad/script.hx');
	trace('onCreate: initScript completado');
	
	trace('onCreate: tentando pegar thinkpad_bfAtlas...');
	var bfAtlasTest = getVar('thinkpad_bfAtlas');
	trace('onCreate: valor de thinkpad_bfAtlas é: ' + bfAtlasTest);
	
	bfAtlasTest.visible = false;
	trace('onCreate: thinkpad_bfAtlas ocultado com sucesso');
	
	trace('onCreate: [FIM]');
}

function onCreatePost()
{
	trace('onCreatePost: [INICIO]');
	
	trace('onCreatePost: acessando thinkpad_baldiAtlas para remover onFinish...');
	getVar('thinkpad_baldiAtlas').atlas.anim.onFinish.removeAll();
	trace('onCreatePost: onFinish removido');
	
	trace('onCreatePost: adicionando novo onFinish...');
	getVar('thinkpad_baldiAtlas').atlas.anim.onFinish.add((anim) -> {
		trace('onCreatePost (CALLBACK): tocando idle-mad');
		getVar('thinkpad_baldiAtlas').playAnim('idle-mad');
	});
	trace('onCreatePost: novo onFinish adicionado');
	
	trace('onCreatePost: checando PlayState.isStoryMode (' + PlayState.isStoryMode + ')');
	if (PlayState.isStoryMode)
	{
		trace('onCreatePost: carregando voices e inst...');
		Paths.voices('expulsion');
		Paths.inst('expulsion');
		trace('onCreatePost: arquivos de som carregados');
	}
	trace('onCreatePost: [FIM]');
}

function onEndSong()
{
	trace('onEndSong: [INICIO]');
	Story.mathMisses = 0;
	
	trace('onEndSong: checando PlayState.isStoryMode (' + PlayState.isStoryMode + ')');
	if (PlayState.isStoryMode)
	{
		trace('onEndSong: pulando transicoes de tela');
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
	}
	
	trace('onEndSong: [FIM - Retornando SCRIPT_CONTINUE]');
	return Constants.SCRIPT_CONTINUE;
}

function onEvent(ev, v1, v2, time)
{
	trace('onEvent: DISPARADO -> ev: "' + ev + '", v1: "' + v1 + '", v2: "' + v2 + '"');
	
	switch (ev)
	{
		case 'Set Property':
			trace('onEvent: Entrou no case "Set Property"');
			if (v1 == 'camGame.alpha')
			{
				trace('onEvent: Modificando camGame...');
				camGame.alpha = 1;
				camGame._fxFadeColor = FlxColor.BLACK;
				camGame._fxFadeAlpha = 1 - v2;
				trace('onEvent: camGame modificado com sucesso');
			}
			
			if (v1 == 'camHUD.alpha')
			{
				trace('onEvent: Modificando camHUD...');
				camHUD.alpha = 1;
				camHUD._fxFadeColor = FlxColor.BLACK;
				camHUD._fxFadeAlpha = 1 - v2;
				trace('onEvent: camHUD modificado com sucesso');
			}
		case '':
			trace('onEvent: Entrou no case de Evento Vazio ("")');
			switch (v1)
			{
				case "makeAngry":
					trace('onEvent [makeAngry]: INICIO');
					
					trace('onEvent [makeAngry]: chamando setBaldiAnim...');
					getVar('setBaldiAnim')('-mad');
					
					trace('onEvent [makeAngry]: chamando baldi playAnim...');
					getVar('thinkpad_baldiAtlas').playAnim('failed');
					
					trace('onEvent [makeAngry]: removendo onFinish do baldi...');
					getVar('thinkpad_baldiAtlas').atlas.anim.onFinish.removeAll();
					
					trace('onEvent [makeAngry]: alterando visibilidade do baldi...');
					getVar('thinkpad_baldiAtlas').visible = true;
					
					trace('onEvent [makeAngry]: alterando visibilidade do bf...');
					getVar('thinkpad_bfAtlas').visible = false;
					
					trace('onEvent [makeAngry]: FIM');
					
				case 'fakeCheckMath':
					trace('onEvent [fakeCheckMath]: INICIO');
					
					trace('onEvent [fakeCheckMath]: definindo input -10...');
					getVar('thinkpad_mathResolver').input = -10;
					
					trace('onEvent [fakeCheckMath]: resolvendo math...');
					getVar('thinkpad_mathResolver').resolveMath();
					
					trace('onEvent [fakeCheckMath]: substituindo texto...');
					var intend = getVar('thinkpad_mathResolver').intendedValue;
					trace('onEvent [fakeCheckMath]: intendedValue é ' + intend);
					getVar('thinkpad_thinkPadText').text = StringTools.replace(getVar('thinkpad_thinkPadText').text, '= ' + intend, '');
					
					trace('onEvent [fakeCheckMath]: pegando resposta do bf...');
					var bfAns = getBfAnswer();
					trace('onEvent [fakeCheckMath]: resposta gerada: ' + bfAns);
					getVar('thinkpad_typedText').text = bfAns;
					
					trace('onEvent [fakeCheckMath]: FIM');
					
				default:
					trace('onEvent: v1 não reconhecido no evento vazio -> ' + v1);
			}
		default:
		  //é
	}
}

function getBfAnswer()
{
	trace('getBfAnswer: Sorteando resposta...');
	var res = RandomUtil.getObject(['31718', '90621', '94150', '0', '12', '42', '37.569']);
	trace('getBfAnswer: Resultado sorteado -> ' + res);
	return res;
}