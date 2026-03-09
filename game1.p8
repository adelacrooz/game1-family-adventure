pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- game1: family adventure prototype
-- arrows: move  o: jump/interact  x: close menu

-- ===========================
-- scene manager
-- ===========================
scene="outdoor"

spawns={
 outdoor={x=24,y=40},
 floor1={x=61,y=60},
 floor2={x=61,y=60},
 bedroom={x=61,y=60},
}

function goto_scene(s)
 if scene=="outdoor" and s~="outdoor" then music(-1) end
 scene=s
 local sp=spawns[s]
 p.x,p.y=sp.x,sp.y
 p.vx,p.vy=0,0
 p.on_ground=false
 if s=="outdoor" then music(0,7) end
end

-- ===========================
-- player
-- ===========================
p={x=24,y=40,vx=0,vy=0,w=6,h=8,on_ground=false,
   anim_t=0,facing=1,land_flash=0,is_dir_flash=false,
   prev_on_ground=false,prev_vx=0,air_sprint=false}
coyote_timer=0
jump_buffer=0

-- outdoor physics constants
gravity=0.35
max_fall=4
jump_force=-7
move_speed=2.2
move_accel=0.4
ground_friction=0.82
coyote_frames=6
jump_buffer_frames=5

-- indoor speed
indoor_spd=1.5

-- ===========================
-- outdoor level
-- ===========================
level_width=960
platforms={
 {0,120,level_width,16},  -- ground
 {48,96,48,8},
 {128,72,48,8},
 {208,96,48,8},
 {288,56,64,8},
 {80,48,32,8},
 {260,32,24,8},
 -- area 2
 {400,96,64,8},
 {480,64,48,8},
 {560,96,56,8},
 {440,40,32,8},
 {520,24,24,8},
 -- area 3
 {640,96,48,8},
 {720,72,64,8},
 {800,96,48,8},
 {680,48,40,8},
 {760,32,32,8},
 -- area 4
 {880,96,80,8},
 {920,56,40,8},
 {860,36,32,8},
}

-- house door trigger (left edge of outdoor level)
hdoor={x=0,y=104,w=14,h=16}

-- ===========================
-- music notes
-- ===========================
-- note_defs: {x, y, pico-8 color}
-- colors: 8=red  12=blue  10=yellow
-- dset slots: 0-7 red, 8-15 blue, 16-23 yellow
note_defs={
 -- 8 red  (area 1 focus)
 {72,88,8},{152,64,8},{232,88,8},{320,48,8},
 {88,40,8},{270,24,8},{424,88,8},{500,56,8},
 -- 8 blue (area 2-3)
 {580,88,12},{456,32,12},{532,16,12},{664,88,12},
 {752,64,12},{824,88,12},{700,40,12},{776,24,12},
 -- 8 yellow (area 3-4 + accessible ground notes)
 {900,88,10},{940,48,10},{876,28,10},{40,110,10},
 {180,110,10},{460,110,10},{620,88,10},{840,72,10},
}

-- maps pico-8 color to inv_notes key
note_col={[8]="r",[12]="b",[10]="y"}

-- active (uncollected) notes on the map
notes={}

-- inventory: note counts per color
inv_notes={r=0,b=0,y=0}

-- animation timer
note_t=0

function init_notes()
 notes={}
 inv_notes={r=0,b=0,y=0}
 for i,nd in ipairs(note_defs) do
  local slot=i-1
  if dget(slot)==0 then
   add(notes,{x=nd[1],y=nd[2],c=nd[3],id=slot})
  else
   inv_notes[note_col[nd[3]]]+=1
  end
 end
end

function collect_notes()
 for n in all(notes) do
  if rect_overlap(p.x,p.y,p.w,p.h,n.x-3,n.y-3,6,6) then
   dset(n.id,1)
   inv_notes[note_col[n.c]]+=1
   del(notes,n)
  end
 end
end

-- ===========================
-- piano (floor1 living room)
-- ===========================
piano={x=10,y=78,w=20,h=12}  -- hotspot in floor1

piano_open=false
piano_sel=1    -- selected slot: 1=red 2=blue 3=yellow
piano_play=0   -- countdown (>0 = playing animation)

-- {display name, note color, inv_notes key}
songs={
 {"lullaby",  8,"r"},
 {"march",   12,"b"},
 {"family",  10,"y"},
}

-- ===========================
-- resources
-- ===========================
inv={wood=0,berries=0,herbs=0,fish=0,net=0,jam=0,soup=0,pie=0}

-- task flags (loaded from dset in _init)
-- fish: 0=none 1=dad asked 2=delivered
tasks={fish=0}

-- {x,y,typ,col} ヌ█⬆️ renewable outdoor gather spots
res_nodes={
 {x=295,y=48, typ="berries",col=8},
 {x=340,y=112,typ="fish",   col=12},
 {x=600,y=112,typ="herbs",  col=11},
 {x=760,y=112,typ="wood",   col=4},
}

near_node=nil      -- set each frame in update_outdoor
res_flash=0        -- pickup feedback countdown
last_gathered=""   -- type name of last gathered resource

-- ===========================
-- npcs (floor1 patrols)
-- ===========================
npcs={
 {x=20,y=50,vx=0.5,px1=10,px2=50, col=9, name="dad"},
 {x=70,y=40,vx=0.5,px1=60,px2=110,col=14,name="mom"},
 {x=80,y=65,vx=0.5,px1=65,px2=105,col=11,name="bro"},
}

function update_npcs()
 for n in all(npcs) do
  n.x+=n.vx
  if n.x>=n.px2 then n.vx=-abs(n.vx)
  elseif n.x<=n.px1 then n.vx=abs(n.vx)
  end
 end
end

function draw_npcs()
 for n in all(npcs) do
  circfill(n.x+3,n.y+4,4,n.col)
  print(n.name,n.x-2,n.y-7,7)
  if not dlg_open and
   rect_overlap(p.x,p.y,p.w,p.h,n.x-2,n.y-2,14,14) then
   print("o:talk",n.x-4,n.y-14,7)
  end
 end
end

-- ===========================
-- dialogue
-- ===========================
-- returns the right line sequence based on task state
function get_dlg(who)
 if who=="dad" then
  if tasks.fish==2 then
   return {"thanks, sport!","that fish was","delicious!"}
  elseif tasks.fish==1 then
   if inv.fish>0 then
    return {"a fish! perfect,","hand it over!"}
   else
    return {"any luck with","that fish yet?"}
   end
  else
   return {"hey, sport!","catch me a fish?","for dinner!"}
  end
 elseif who=="mom" then
  return {"hi sweetie!","have you tried","the piano?"}
 elseif who=="bro" then
  return {"wanna play outside?","i saw a frog","at the lake!"}
 end
 return {"..."}
end

dlg_open=false
dlg_who=""   -- "dad","mom","bro"
dlg_i=1      -- current line index
dlg_seq={}   -- active line sequence

function open_dlg(who)
 local lines=get_dlg(who)
 dlg_open=true
 dlg_who=who
 dlg_i=1
 dlg_seq=lines
end

function on_dlg_close()
 if dlg_who=="dad" then
  if tasks.fish==0 then
   tasks.fish=1
   dset(30,1)
  elseif tasks.fish==1 and inv.fish>0 then
   inv.fish-=1
   tasks.fish=2
   dset(30,2)
  end
 end
end

function update_dlg()
 if btnp(4) or btnp(5) then
  dlg_i+=1
  if dlg_i>#dlg_seq then
   dlg_open=false
   on_dlg_close()
  end
 end
end

function draw_dlg()
 -- box
 rectfill(4,88,123,122,0)
 rect(4,88,123,122,7)
 -- npc name (colored)
 local ncol=7
 for n in all(npcs) do
  if n.name==dlg_who then ncol=n.col break end
 end
 print(dlg_who..":",8,91,ncol)
 -- current line
 if dlg_i<=#dlg_seq then
  print(dlg_seq[dlg_i],8,100,7)
 end
 -- footer
 if dlg_i<#dlg_seq then
  print("o:next",90,114,6)
 else
  print("o:close",88,114,6)
 end
end

-- ===========================
-- workbench (floor1)
-- ===========================
wb={x=96,y=78,w=20,h=12}
wb_open=false
wb_sel=1

-- {name, ctxt=cost display, cost={item=qty}, res=result, qty}
recipes={
 {name="net", ctxt="2 wood",
  cost={wood=2},   res="net",qty=1},
 {name="jam", ctxt="2b+1h",
  cost={berries=2,herbs=1},res="jam",qty=1},
}

function can_craft(r)
 for item,qty in pairs(r.cost) do
  if (inv[item] or 0)<qty then return false end
 end
 return true
end

function update_wb()
 if btnp(2) then wb_sel=max(1,wb_sel-1)
 elseif btnp(3) then wb_sel=min(#recipes,wb_sel+1)
 elseif btnp(4) then
  local r=recipes[wb_sel]
  if can_craft(r) then
   for item,qty in pairs(r.cost) do inv[item]-=qty end
   inv[r.res]+=r.qty
  end
 elseif btnp(5) then wb_open=false
 end
end

function draw_wb_menu()
 rectfill(10,28,117,102,0)
 rect(10,28,117,102,7)
 print("--workbench--",26,32,7)
 for i,r in ipairs(recipes) do
  local sy=46+i*12
  local col=can_craft(r) and 7 or 5
  local cur=i==wb_sel and ">" or " "
  print(cur..r.name,16,sy,col)
  print(r.ctxt,70,sy,col)
 end
 -- current inv
 print("w"..inv.wood.." b"..inv.berries,16,80,6)
 print("h"..inv.herbs.." f"..inv.fish,16,87,6)
 print("o:craft  x:close",16,95,6)
end

-- ===========================
-- cooking (stove, floor1)
-- ===========================
stove={x=96,y=50,w=20,h=12}
stove_open=false
stove_sel=1

cook_recipes={
 {name="soup",ctxt="1f+1h",cost={fish=1,herbs=1},res="soup",qty=1},
 {name="pie", ctxt="2b",   cost={berries=2},      res="pie", qty=1},
}

function update_stove()
 if btnp(2) then stove_sel=max(1,stove_sel-1)
 elseif btnp(3) then stove_sel=min(#cook_recipes,stove_sel+1)
 elseif btnp(4) then
  local r=cook_recipes[stove_sel]
  if can_craft(r) then
   for item,qty in pairs(r.cost) do inv[item]-=qty end
   inv[r.res]+=r.qty
  end
 elseif btnp(5) then stove_open=false
 end
end

function draw_stove_menu()
 rectfill(10,28,117,102,0)
 rect(10,28,117,102,7)
 print("--kitchen--",30,32,7)
 for i,r in ipairs(cook_recipes) do
  local sy=46+i*12
  local col=can_craft(r) and 7 or 5
  local cur=i==stove_sel and ">" or " "
  print(cur..r.name,16,sy,col)
  print(r.ctxt,70,sy,col)
 end
 print("b"..inv.berries.." h"..inv.herbs,16,80,6)
 print("f"..inv.fish,16,87,6)
 print("o:cook  x:close",16,95,6)
end

-- ===========================
-- critters
-- ===========================
caught={frog=false,crab=false,butterfly=false,
        beetle=false,firefly=false,snake=false}

critter_types={"frog","crab","butterfly","beetle","firefly","snake"}
critter_slot={frog=24,crab=25,butterfly=26,beetle=27,firefly=28,snake=29}
critter_col= {frog=11,crab=8, butterfly=14,beetle=3, firefly=10,snake=3}
critter_abbr={frog="frog",crab="crab",butterfly="bfly",
              beetle="btle",firefly="ffly",snake="snke"}

critter_defs={
 {x=60, y=112,typ="frog",      fly=false,zx1=10, zx2=380,zy1=108,zy2=116},
 {x=200,y=112,typ="crab",      fly=false,zx1=10, zx2=380,zy1=108,zy2=116},
 {x=310,y=44, typ="butterfly", fly=true, zx1=270,zx2=420,zy1=30, zy2=56},
 {x=680,y=112,typ="beetle",    fly=false,zx1=560,zx2=820,zy1=108,zy2=116},
 {x=520,y=96, typ="firefly",   fly=true, zx1=400,zx2=640,zy1=80, zy2=114},
 {x=820,y=112,typ="snake",     fly=false,zx1=700,zx2=950,zy1=108,zy2=116},
}

critters={}
near_critter=nil

function init_critters()
 critters={}
 for cd in all(critter_defs) do
  if not caught[cd.typ] then
   add(critters,{
    x=cd.x,y=cd.y,typ=cd.typ,fly=cd.fly,
    zx1=cd.zx1,zx2=cd.zx2,zy1=cd.zy1,zy2=cd.zy2,
    vx=0,vy=0,t=0
   })
  end
 end
end

function update_critters()
 for c in all(critters) do
  c.t-=1
  if c.t<=0 then
   c.vx=(rnd(2)-1)*0.7
   if c.fly then c.vy=(rnd(2)-1)*0.4 end
   c.t=flr(rnd(80))+30
  end
  c.x=mid(c.zx1,c.x+c.vx,c.zx2)
  if c.fly then c.y=mid(c.zy1,c.y+c.vy,c.zy2) end
  if c.x<=c.zx1 or c.x>=c.zx2 then c.vx*=-1 end
  if c.fly and (c.y<=c.zy1 or c.y>=c.zy2) then c.vy*=-1 end
 end
end

function draw_critters()
 for c in all(critters) do
  circfill(c.x+3,c.y+3,3,critter_col[c.typ])
  pset(c.x+3,c.y+3,7)
 end
end

function draw_bedroom_display()
 print("critter stand",28,6,7)
 for i,t in ipairs(critter_types) do
  local sx=6+((i-1)%3)*38
  local sy=20+flr((i-1)/3)*30
  rectfill(sx,sy,sx+18,sy+18,0)
  rect(sx,sy,sx+18,sy+18,7)
  if caught[t] then
   circfill(sx+9,sy+9,5,critter_col[t])
   pset(sx+9,sy+9,7)
  else
   print("?",sx+6,sy+6,5)
  end
  print(critter_abbr[t],sx+1,sy+20,caught[t] and 7 or 5)
 end
end

function update_piano()
 -- during play animation: just count down, no input
 if piano_play>0 then
  piano_play-=1
  return
 end
 if btnp(2) then piano_sel=max(1,piano_sel-1)
 elseif btnp(3) then piano_sel=min(3,piano_sel+1)
 elseif btnp(4) then  -- O: play selected song
  if inv_notes[songs[piano_sel][3]]==8 then
   piano_play=90
   -- sfx(piano_sel-1)  -- compose in pico-8 sfx editor, then uncomment
  end
 elseif btnp(5) then  -- X: close
  piano_open=false
 end
end

function draw_piano_menu()
 -- sparkle + flash during playback
 if piano_play>0 then
  if piano_play>82 then
   rectfill(0,0,127,127,7)  -- brief white flash at start
  end
  for i=1,14 do
   pset(rnd(128),rnd(128),rnd(15)+1)
  end
 end

 -- menu box
 rectfill(20,26,107,104,0)
 rect(20,26,107,104,7)
 print("-- piano --",32,30,7)

 -- song slots
 for i,s in ipairs(songs) do
  local sy=42+i*14
  local cnt=inv_notes[s[3]]
  local full=cnt==8
  local cursor=i==piano_sel and ">" or " "
  local col=full and s[2] or 5
  print(cursor..s[1].." "..cnt.."/8",26,sy,col)
  if i==piano_sel and not full then
   print("  need all 8!",26,sy+7,5)
  end
 end

 -- footer
 if piano_play>0 then
  print("  ~playing~",34,92,10)
 else
  print("o:play  x:close",24,94,6)
 end
end

-- ===========================
-- indoor rooms
-- ===========================
rooms={
 floor1={
  walls={
   {0,0,128,4},{0,124,128,4},
   {0,0,4,128},{124,0,4,128},
  },
  triggers={
   {x=54,y=4, w=20,h=12,dest="floor2", lbl="up"},
   {x=54,y=108,w=20,h=12,dest="outdoor",lbl="door"},
  },
 },
 floor2={
  walls={
   {0,0,128,4},{0,124,128,4},
   {0,0,4,128},{124,0,4,128},
  },
  triggers={
   {x=54,y=4, w=20,h=12,dest="bedroom",lbl="room"},
   {x=54,y=108,w=20,h=12,dest="floor1", lbl="dn"},
  },
 },
 bedroom={
  walls={
   {0,0,128,4},{0,124,128,4},
   {0,0,4,128},{124,0,4,128},
  },
  triggers={
   {x=54,y=108,w=20,h=12,dest="floor2",lbl="exit"},
  },
 },
}

-- ===========================
-- collision helpers
-- ===========================
function rect_overlap(ax,ay,aw,ah,bx,by,bw,bh)
 return ax<bx+bw and ax+aw>bx and ay<by+bh and ay+ah>by
end

function resolve_x_out()
 for pl in all(platforms) do
  if rect_overlap(p.x+p.vx,p.y,p.w,p.h,pl[1],pl[2],pl[3],pl[4]) then
   p.vx=0 return
  end
 end
 p.x+=p.vx
end

function resolve_y_out()
 p.on_ground=false
 for pl in all(platforms) do
  if rect_overlap(p.x,p.y+p.vy,p.w,p.h,pl[1],pl[2],pl[3],pl[4]) then
   if p.vy>0 then
    p.y=pl[2]-p.h
    p.on_ground=true
   else
    p.y=pl[2]+pl[4]
   end
   p.vy=0 return
  end
 end
 p.y+=p.vy
end

function resolve_indoor(walls)
 local nx=p.x+p.vx
 for w in all(walls) do
  if rect_overlap(nx,p.y,p.w,p.h,w[1],w[2],w[3],w[4]) then
   nx=p.x break
  end
 end
 p.x=nx
 local ny=p.y+p.vy
 for w in all(walls) do
  if rect_overlap(p.x,ny,p.w,p.h,w[1],w[2],w[3],w[4]) then
   ny=p.y break
  end
 end
 p.y=ny
end

function check_triggers(trig)
 for t in all(trig) do
  if rect_overlap(p.x,p.y,p.w,p.h,t.x,t.y,t.w,t.h) then
   goto_scene(t.dest) return
  end
 end
end

-- ===========================
-- init
-- ===========================
function _init()
 cartdata("game1_save")
 init_notes()
 tasks.fish=dget(30)
 for i,t in ipairs(critter_types) do
  caught[t]=dget(critter_slot[t])==1
 end
 init_critters()
 goto_scene("outdoor")
end

function do_jump()
 sfx(0)  -- jump sound (change 0 to your sfx slot)
 p.vy=jump_force
 p.on_ground=false
 coyote_timer=0
 jump_buffer=0
end

-- ===========================
-- player animation
-- ===========================
function update_player_anim()
 p.anim_t+=1
 -- indoors treat player as always grounded
 local grnd=scene~="outdoor" or p.on_ground
 -- landing flash
 if grnd and not p.prev_on_ground then
  p.land_flash=10
  p.is_dir_flash=false
 end
 -- direction-change flash (while running)
 if grnd and p.land_flash<=0 and btn(5)
  and abs(p.prev_vx)>0.05
  and (p.vx>0)~=(p.prev_vx>0) then
  p.land_flash=8
  p.is_dir_flash=true
  sfx(7)
 end
 if p.land_flash>0 then p.land_flash-=1 end
 if p.vx>0.1 then p.facing=1 elseif p.vx<-0.1 then p.facing=-1 end
 p.prev_on_ground=grnd
 p.prev_vx=p.vx
end

function get_player_spr()
 local grnd=scene~="outdoor" or p.on_ground
 local fx=p.facing<0
 if p.land_flash>0 then return 8,p.is_dir_flash~=fx end
 if not grnd then
  if p.vy<0 then return 6,fx else return 7,fx end
 end
 if abs(p.vx)>0.1 then
  local spd=btn(5) and 4 or 6
  return 3+flr(p.anim_t/spd)%3,fx
 end
 return 1+flr(p.anim_t/20)%2,fx
end

function draw_player()
 local s,fx=get_player_spr()
 spr(s,p.x-1,p.y,1,1,fx)
end

-- ===========================
-- update
-- ===========================
function _update()
 if scene=="outdoor" then
  update_outdoor()
 else
  update_indoor()
 end
end

function update_outdoor()
 note_t+=1
 if res_flash>0 then res_flash-=1 end

 -- find near critter
 near_critter=nil
 for c in all(critters) do
  if rect_overlap(p.x,p.y,p.w,p.h,c.x-3,c.y-3,10,10) then
   near_critter=c break
  end
 end

 -- find nearest resource node within reach
 near_node=nil
 for rn in all(res_nodes) do
  if rect_overlap(p.x,p.y,p.w,p.h,rn.x-6,rn.y-6,14,14) then
   near_node=rn break
  end
 end

 if p.on_ground then
  coyote_timer=coyote_frames
 else
  coyote_timer=max(0,coyote_timer-1)
 end
 if jump_buffer>0 then jump_buffer-=1 end

 if p.on_ground then p.air_sprint=btn(5) end
 local spd=p.air_sprint and move_speed*1.7 or move_speed
 if btn(0) then
  p.vx=max(-spd,p.vx-move_accel)
 elseif btn(1) then
  p.vx=min(spd,p.vx+move_accel)
 elseif p.on_ground then
  p.vx*=ground_friction
  if abs(p.vx)<0.1 then p.vx=0 end
 end

 if btnp(4) then
  if near_critter and inv.net>0 then
   caught[near_critter.typ]=true
   dset(critter_slot[near_critter.typ],1)
   del(critters,near_critter)
   near_critter=nil
  elseif near_node then
   inv[near_node.typ]+=1
   last_gathered=near_node.typ
   res_flash=30
  else
   jump_buffer=jump_buffer_frames
  end
 end
 if jump_buffer>0 and (p.on_ground or coyote_timer>0) then
  do_jump()
 end

 p.vy=min(p.vy+gravity,max_fall)

 resolve_x_out()
 resolve_y_out()

 if p.on_ground and jump_buffer>0 then do_jump() end

 p.x=mid(0,p.x,level_width-p.w)
 collect_notes()
 update_critters()

 if rect_overlap(p.x,p.y,p.w,p.h,hdoor.x,hdoor.y,hdoor.w,hdoor.h) then
  goto_scene("floor1")
 end
 update_player_anim()
end

function update_indoor()
 -- dialogue captures all input when open
 if dlg_open then
  update_dlg()
  return
 end
 -- stove menu captures all input when open
 if stove_open then
  update_stove()
  return
 end
 -- workbench menu captures all input when open
 if wb_open then
  update_wb()
  return
 end
 -- piano menu captures all input when open
 if piano_open then
  update_piano()
  return
 end

 local rm=rooms[scene]
 p.vx,p.vy=0,0
 if btn(0) then p.vx=-indoor_spd end
 if btn(1) then p.vx= indoor_spd end
 if btn(2) then p.vy=-indoor_spd end
 if btn(3) then p.vy= indoor_spd end
 resolve_indoor(rm.walls)
 check_triggers(rm.triggers)

 if scene=="floor1" then
  -- piano: open on O when nearby
  if rect_overlap(p.x,p.y,p.w,p.h,piano.x-2,piano.y-2,piano.w+4,piano.h+4) then
   if btnp(4) then piano_open=true end
  end
  -- stove: open on O when nearby
  if rect_overlap(p.x,p.y,p.w,p.h,stove.x-2,stove.y-2,stove.w+4,stove.h+4) then
   if btnp(4) then stove_open=true end
  end
  -- workbench: open on O when nearby
  if rect_overlap(p.x,p.y,p.w,p.h,wb.x-2,wb.y-2,wb.w+4,wb.h+4) then
   if btnp(4) then wb_open=true end
  end
  -- npcs: talk on O when nearby
  for n in all(npcs) do
   if rect_overlap(p.x,p.y,p.w,p.h,n.x-2,n.y-2,14,14) then
    if btnp(4) then open_dlg(n.name) end
    break
   end
  end
  update_npcs()
 end
 update_player_anim()
end

-- ===========================
-- draw
-- ===========================
function _draw()
 if scene=="outdoor" then
  draw_outdoor()
 else
  draw_indoor()
 end
end

function draw_outdoor()
 cls(1)
 local cam_x=mid(0,p.x-64,level_width-128)
 camera(cam_x,0)

 rectfill(0,0,level_width,120,12)

 -- mountains
 rectfill(560,70,680,120,5)
 rectfill(578,50,662,70,5)
 rectfill(596,32,644,50,5)
 rectfill(614,18,626,32,5)
 rectfill(613,15,627,20,7)
 rectfill(700,78,840,120,5)
 rectfill(720,56,820,78,5)
 rectfill(742,36,798,56,5)
 rectfill(760,20,780,36,5)
 rectfill(759,17,781,23,7)

 -- lake
 rectfill(10,96,390,120,1)
 rectfill(10,96,390,99,12)
 line(20,106,380,106,13)
 line(20,113,380,113,13)

 -- platforms
 for pl in all(platforms) do
  rectfill(pl[1],pl[2],pl[1]+pl[3]-1,pl[2]+pl[4]-1,3)
  rect(pl[1],pl[2],pl[1]+pl[3]-1,pl[2]+pl[4]-1,7)
 end

 -- critters
 draw_critters()

 -- resource nodes
 for rn in all(res_nodes) do
  circfill(rn.x+3,rn.y+3,5,rn.col)
  pset(rn.x+3,rn.y+3,7)
 end

 -- music notes (bobbing circles)
 for n in all(notes) do
  local by=flr(n.y+sin(note_t/60+n.id*0.13)*2)
  circfill(n.x+2,by+2,3,n.c)
  pset(n.x+2,by+2,7)  -- white center
 end

 -- house door
 rectfill(hdoor.x,hdoor.y,hdoor.x+hdoor.w-1,119,9)
 print("house",1,hdoor.y-6,7)

 -- player
 draw_player()

 -- capture prompt (world space, above critter)
 if near_critter then
  if inv.net>0 then
   print("o:catch",near_critter.x-6,near_critter.y-10,7)
  else
   print("need net",near_critter.x-8,near_critter.y-10,8)
  end
 end

 -- gather prompt (drawn in world space, above player)
 if near_node then
  print("o:"..near_node.typ,p.x-10,p.y-10,7)
 end

 camera()
 -- note HUD: colored dot + count
 circfill(4,4,2,8)  print(inv_notes.r.."/8",9, 2,8)
 circfill(4,11,2,12) print(inv_notes.b.."/8",9, 9,12)
 circfill(4,18,2,10) print(inv_notes.y.."/8",9,16,10)
 -- resource HUD (top-right)
 if res_flash>0 then
  print("+1 "..last_gathered,80,2,7)
 else
  print("w"..inv.wood.." b"..inv.berries,76,2,5)
  print("h"..inv.herbs.." f"..inv.fish,76,9,5)
 end
 print("arrows:move  o:jump",2,120,6)
end

function draw_indoor()
 local rm=rooms[scene]
 cls(4)
 rectfill(4,4,123,123,15)

 -- walls
 for w in all(rm.walls) do
  rectfill(w[1],w[2],w[1]+w[3]-1,w[2]+w[4]-1,4)
 end

 -- triggers
 for t in all(rm.triggers) do
  rectfill(t.x,t.y,t.x+t.w-1,t.y+t.h-1,9)
  print(t.lbl,t.x+2,t.y+3,0)
 end

 -- floor1 furniture
 if scene=="floor1" then
  -- piano
  rectfill(piano.x,piano.y,piano.x+piano.w-1,piano.y+piano.h-1,1)
  rect(piano.x,piano.y,piano.x+piano.w-1,piano.y+piano.h-1,12)
  print("*",piano.x+8,piano.y+3,7)
  if not piano_open and not dlg_open and
   rect_overlap(p.x,p.y,p.w,p.h,piano.x-4,piano.y-4,piano.w+8,piano.h+8) then
   print("o:piano",piano.x-2,piano.y-7,7)
  end
  -- stove
  rectfill(stove.x,stove.y,stove.x+stove.w-1,stove.y+stove.h-1,8)
  rect(stove.x,stove.y,stove.x+stove.w-1,stove.y+stove.h-1,7)
  print("st",stove.x+5,stove.y+3,7)
  if not stove_open and not dlg_open and
   rect_overlap(p.x,p.y,p.w,p.h,stove.x-4,stove.y-4,stove.w+8,stove.h+8) then
   print("o:cook",stove.x-2,stove.y-7,7)
  end
  -- workbench
  rectfill(wb.x,wb.y,wb.x+wb.w-1,wb.y+wb.h-1,4)
  rect(wb.x,wb.y,wb.x+wb.w-1,wb.y+wb.h-1,7)
  print("wb",wb.x+5,wb.y+3,7)
  if not wb_open and not dlg_open and
   rect_overlap(p.x,p.y,p.w,p.h,wb.x-4,wb.y-4,wb.w+8,wb.h+8) then
   print("o:craft",wb.x-4,wb.y-7,7)
  end
 end

 -- bedroom display stands
 if scene=="bedroom" then draw_bedroom_display() end

 -- npcs (floor1 only)
 if scene=="floor1" then draw_npcs() end

 -- player
 draw_player()

 -- menu overlays
 if stove_open  then draw_stove_menu()  end
 if wb_open     then draw_wb_menu()     end
 if piano_open  then draw_piano_menu()  end
 if dlg_open    then draw_dlg()         end

 -- hud
 print("arrows:move",2,2,7)
 print(scene,2,10,6)
end
__gfx__
00000000001111100011111000011111000111110001111100011111000111110000000000000000000000000000000000000000000000000000000000000000
00000000001ffff0001ffff00001ffff0001ffff0001ffff0001ffff0001ffff0111110000000000000000000000000000000000000000000000000000000000
0000000000f71f1000f71f10000ff71f000ff71f000ff71f000ff71f000ff71f01ffff0000000000000000000000000000000000000000000000000000000000
0000000000fffff000fffef0000ffffe000ffffe000ffffe000ffffe000ffffe0f71f10000000000000000000000000000000000000000000000000000000000
00000000000ff000002222000f2220000f2220000f22200000222000000022200fffef0000000000000000000000000000000000000000000000000000000000
00000000002222000f0220f00002200000022000000220000f0220000000220f002222f000000000000000000000000000000000000000000000000000000000
000000000f02d0f00002d0000220d000002d00000dd0200000d20000000002d00f022d0000000000000000000000000000000000000000000000000000000000
0000000000200d0000200d000000d000002d0000000020000d2000000000002d000022dd00000000000000000000000000000000000000000000000000000000
__sfx__
0102000004050080500a0500f05013050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112000003744030250a7040a005137441302508744080251b7110a704037440302524615080240a7440a02508744087250a7040c0241674416025167251652527515140240c7440c025220152e015220150a525
011200000c033247151f5152271524615227151b5051b5151f5201f5201f5221f510225212252022522225150c0331b7151b5151b715246151b5151b5051b515275202752027522275151f5211f5201f5221f515
011200000c0330802508744080250872508044187151b7151b7000f0251174411025246150f0240c7440c0250c0330802508744080250872508044247152b715275020f0251174411025246150f0240c7440c025
011200002452024520245122451524615187151b7151f71527520275202751227515246151f7151b7151f715295202b5212b5122b5152461524715277152e715275002e715275022e715246152b7152771524715
011200002352023520235122351524615177151b7151f715275202752027512275152461523715277152e7152b5202c5212c5202c5202c5202c5222c5222c5222b5202b5202b5222b515225151f5151b51516515
011200000c0330802508744080250872508044177151b7151b7000f0251174411025246150f0240b7440b0250c0330802508744080250872524715277152e715080242e715080242e715246150f0240c7440c025
d70800002f0262b02626006270263f0063f0062c0062200632006020061e006280060c0063c006220060c0062c006300060a0063200604006220062a006080062c006000061e0062000638006000063800636006
__music__
00 01000000
00 01424344
00 01024344
00 01024344
01 01024344
00 01024344
00 03044344
02 05064344

