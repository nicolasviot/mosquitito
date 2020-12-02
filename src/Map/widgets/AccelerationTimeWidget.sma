use core
use base
use display
use gui

import Map.widgets.Button
//widgets that can control the map timer
_define_
AccelerationTimeWidget (Process map){

    svg = loadFromXML ("./ressources/timer.svg")
    
    Component widget {
        Translation t (0,0)
        Scaling scaling (0.4,0.4,0,0)
        map.clipping.width +map.t.tx -300 =:> t.tx
        map.clipping.height +map.t.ty - 250=:> t.ty
        Component previousButton {
            FillOpacity a (0.4)
            FillColor fc (50,50,50)
            previousSvg << svg.layerPrevious
            r aka previousSvg.previous
            FSM fsm {
                State idle {
                  0.4 =: a.a
                  50 =: fc.r
                }
                State entered{
                  0.8 =: a.a
                }
                State pressed {
                  150 =: fc.r
                }

                idle->entered (r.enter)
                entered -> idle (r.leave)
                entered -> pressed (r.press)
                pressed->entered (r.release,map.previousStep)
                pressed->idle (map.frame.release)
            }
        }
        Component nextButton {
            FillOpacity a (0.4)
            FillColor fc (50,50,50)
            nextSvg << svg.layerNext
            r aka nextSvg.next
            FSM fsm {
                State idle {
                  0.4 =: a.a
                  50 =: fc.r
                }
                State entered{
                  0.8 =: a.a
                }
                State pressed {
                  150 =: fc.r
                }

                idle->entered (r.enter)
                entered -> idle (r.leave)
                entered -> pressed (r.press)
                pressed->entered (r.release,map.nextStep)
                pressed->idle (map.frame.release)
            }
        }

        Spike changeBool 
        AssignmentSequence changeBoolSeq (1){
            !map.paused =: map.paused
        }
        changeBool-> changeBoolSeq

        FSM pausedOrNot {
            State pause {
                Component pauseButton {
                    FillOpacity a (0.4)
                    FillColor fc (50,50,50)
                    pausesSvg << svg.layerPause
                    r aka pausesSvg.pause
                     FSM fsm {
                        State idle {
                          0.4 =: a.a
                          50 =: fc.r
                        }
                        State entered{
                          0.8 =: a.a
                        }
                        State pressed {
                          150 =: fc.r
                        }

                        idle->entered (r.enter)
                        entered -> idle (r.leave)
                        entered -> pressed (r.press)
                        pressed->entered (r.release,changeBool)
                        pressed->idle (map.frame.release)
                    }
                }
            }

            State play {
                Component playButton {
                    FillOpacity a (1)
                    FillColor fc (50,50,50)
                    playSvg << svg.layerPlay
                    r aka playSvg.play 
                    FSM fsm {
                        State idle {
                          0.25 =: a.a
                          50 =: fc.r
                        }
                        State entered{
                          0.8 =: a.a
                        }
                        State pressed {
                          150 =: fc.r
                        }

                        idle->entered (r.enter)
                        entered -> idle (r.leave)
                        entered -> pressed (r.press)
                        pressed->entered (r.release,changeBool)
                        pressed->idle (map.frame.release)
                    }
                }  
            }

            pause -> play (map.paused.true)
            play -> pause (map.paused.false)
        }



        Component speedDownButton {
            FillOpacity a (1)
            FillColor fc (50,50,50)
            speedDownSvg << svg.layerSpeedDown
            r aka speedDownSvg.speedDown
            FSM fsm {
                State idle {
                  0.25 =: a.a
                  50 =: fc.r
                }
                State entered{
                  0.8 =: a.a
                }
                State pressed {
                  150 =: fc.r
                }

                idle->entered (r.enter)
                entered -> idle (r.leave)
                entered -> pressed (r.press)
                pressed->entered (r.release,map.decelerateTime)
                pressed->idle (map.frame.release)
            }
        }
        Component speedUpButton {
            FillOpacity a (1)
            FillColor fc (50,50,50)
            speedUpSvg << svg.layerSpeedUp
            r aka speedUpSvg.speedUp
            FSM fsm {
                State idle {
                  0.25 =: a.a
                  50 =: fc.r
                }
                State entered{
                  0.8 =: a.a
                }
                State pressed {
                  150 =: fc.r
                }

                idle->entered (r.enter)
                entered -> idle (r.leave)
                entered -> pressed (r.press)
                pressed->entered (r.release,map.accelerateTime)
                pressed->idle (map.frame.release)
            }
        }
        Component speed {
            FillOpacity a (0.7)
            FillColor fc (50,50,50)
            speedSvg << svg.layerSpeed
            r aka speedSvg.speed 
            FSM fsm {
                State idle {
                  0.7 =: a.a
                  50 =: fc.r
                }
                State entered{
                  0.8 =: a.a
                }
                idle->entered (r.enter)
                entered -> idle (r.leave)
            }
            text aka speedSvg.speedText.text
            DoubleFormatter dbF (0,2)

            map.timeAcceleration =:> dbF.input
            dbF.output =:> text
            r.width =: speedSvg.speedText.width
        }
    }
}
