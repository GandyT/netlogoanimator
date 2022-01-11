globals [
  ; CONSTANTS
  
  btn-width
  btn-height
  
  ; VARIABLES
  
  setup?
  page
  pageLoad
  buttons
  
  animation
]

to-report isWithin [ xp yp x y width height ]
  ifelse (xp >= x and xp <= (x + width)) and (yp >= y and yp <= (y + height))
  [ report true ]
  [ report false ]
end

to draw-rect [ x y w h c ]
  ask patches with [ pxcor >= x and pxcor <= x + w and pycor >= y and pycor <= y + h] [ set pcolor c ]
end

to clear-page
 ask patches [ set pcolor black ]
 set buttons []
 clear-turtles 
end

to listen-btns
  foreach buttons [ btn -> 
    let callback item 0 btn
    let x item 1 btn
    let y item 2 btn
    let name item 3 btn 
    
    if mouse-down? = true and isWithin mouse-xcor mouse-ycor x y btn-width btn-height = true
    [
      print "Clicked Button!"
      run callback
    ]
  ]
end

to draw-text [ x y text ]
  crt 1 [
    set heading 0
    set label text
    set size 0
    setxy x y
  ]
end 
  

to setup
  ca
  
  ; SET CONSTANTS
  
  set btn-width 40
  set btn-height 20
  
  ; SET MISC
  
  resize-world -200 200 -200 200
  set-patch-size 2
  set page "MENU"
  set pageLoad "NONE"
  set buttons []
  set animation []
  set setup? true
  
  print "Finished Setup!"
end

to register-button [ onclick x y name ] 
  print "Registering Button "
  print name
  ; onclick is a callback function
  
  let buttonObject (list onclick x y name)
  set buttons lput buttonObject buttons 
 
  ; draw button 
  draw-rect x y btn-width + length name btn-height red
  draw-text x + btn-width y + (btn-height / 2) name
  
end

to render-menu
  if page != pageLoad
  [ 
    print "Setting Up Menu"
    clear-page
    
    set pageLoad page 
    ; register buttons
    register-button [[] -> ( set page "ANIMATOR" )] -20 0 "Animate!"
    draw-text 60 50 "SUPER NETLOGO ANIMATOR™"
  ]
  
  listen-btns
end

to render-animator 
  if page != pageLoad
  [
    print "Setting Up Animator"
    clear-page
    
    set pageLoad page
    
    register-button [[] -> ( set page "MENU" )] -200 180 "BACK"
  ]
  
  listen-btns
end 

to go
  if setup? != true [ 
    draw-text 50 50 "LOADING..."
    setup
  ]
  
  if page = "MENU"
  [
    render-menu
  ] 
  
  if page = "ANIMATOR"
  [
    render-animator
  ]
end
