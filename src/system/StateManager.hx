package system;

import luxe.Log.*;
import luxe.Parcel;
import luxe.States;

import components.Fader;
import entities.FadeTransitionSprite;
import definitions.Enums;
import states.BaseState;
import states.LoadState;
import states.Level1State;
import states.Level2State;
import states.SplashState;

class StateManager
{
    private var _states:States;
    private var _current_state:String;
    private var _next_state:String;
    private var _queued_state:String;
    private var _current_parcel:Parcel;
    private var _changeStateEventId:String;
    private var _fader:Fader;

	public function new() 
	{
        _debug("---------- StateManager.new ----------");

        _changeStateEventId = "";
        _current_state = "";
        _next_state = "";
        _queued_state = "";

        // Set up fade overlay

        var fader_sprite = new FadeTransitionSprite();
        _fader = fader_sprite.add(new Fader());
        
        // Subscribe to state change events
        _changeStateEventId = Luxe.events.listen(EventTypes.ChangeState, on_change_state);

        // Go to first state
        _states = new States({ name:'states' });
        _states.add(new SplashState());
        _states.add(new LoadState());        
        _states.add(new Level1State());
        _states.add(new Level2State());        

        _current_state = StateNames.Splash;
        _next_state = StateNames.Splash;
        _states.set(_next_state);

        var state:BaseState = cast _states.current_state;
        _fader.fade_in(state.transition_in_time, on_fade_in_done);
    }

    function on_change_state(e)
    {
        _debug("---------- StateManager.on_change_state, go to state:" + e.state + "----------");

        _next_state = e.state;   

        if (e.parcel != null)
        {
            _current_parcel = e.parcel;
        }     

        var state:BaseState = cast _states.current_state;

        if (state.transition_out_time > 0)
        {
            _fader.fade_out(state.transition_out_time, on_fade_out_done);    
        }
        else
        {
            on_fade_out_done();
        }
    }

    function on_fade_in_done()
    {
        _debug("---------- StateManager.on_fade_in_done ----------");

        var state:BaseState = cast _states.current_state;
        state.post_fade_in();
    }

    function on_fade_out_done()
    {
        _debug("---------- StateManager.on_fade_out_done ----------");

        log("[StateManager] Current state : " + _current_state);
        log("[StateManager] Next state : " + _next_state);        

        _states.unset(_current_state);

        if (_current_state == StateNames.Splash)
        {
            // Destroy preloaded splash resources

            Luxe.resources.destroy(LetterMTexture);
            Luxe.resources.destroy(LetterITexture);
            Luxe.resources.destroy(LetterOTexture);
            Luxe.resources.destroy(LetterSTexture);            
            Luxe.resources.destroy(LogoAnimationJson);
        }

        Main.main_scene.empty();
        Main.mint_renderer.scene.empty();

        if (_current_state == StateNames.Load)
        {
            // Resources for next state loaded, proceed

            _states.set(_next_state);
        }
        else
        {
            if (_current_parcel != null)
            {
                // Assets were loaded from a parcel (i.e. current state is not splash or load)

                _current_parcel.unload();
            }

            // Queue next state and preload resources

            LoadState.next_state = _next_state;            
            _states.set(StateNames.Load);
        }

        var state:BaseState = cast _states.current_state;
        _current_state = state.name;
        _fader.fade_in(state.transition_in_time, on_fade_in_done);                        
    }

    public function destroy() 
    {
        Luxe.events.unlisten(_changeStateEventId);

        if (_states != null)
        {
            _states.destroy();
            _states = null;            
        }

        if (_current_parcel != null)
        {
            _current_parcel.unload();
            _current_parcel = null; 
        }

        _next_state = null;
        _fader = null;
    }
}