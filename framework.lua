-- Decompiled with the Synapse X 2021 Luau decompiler.
-- NOTE: Builtins are approximations and are not actually present in the original code.
-- BUILTINS
local function __builtin_settop(table, index, ...)
   local va, count = {...}, select("#", ...)
   for i = index, index + count - 1 do
       table[i] = va[i]
   end
   end
   -- END BUILTINS
   
   math.randomseed(tick());
   local v1 = game:GetService("RunService"):IsStudio();
   local t_Value_1 = game:GetService("ReplicatedFirst"):WaitForChild("GameData"):WaitForChild("Version", 3).Value;
   local t_LocalPlayer_2 = game:GetService("Players").LocalPlayer;
   while true do
      wait(1);
      if (game:IsLoaded() and shared.require) then
         break;
      end
   end
   local v2 = tick();
   local v3 = shared.require("superusers")[t_LocalPlayer_2.UserId];
   pcall(function()
      --[[
         Name: (empty)
      --]]
      game:GetService("StarterGui"):SetCore("TopbarEnabled", false);
   end);
   local v4 = {};
   local v5 = {};
   local v6 = {};
   local v7 = {};
   local v8 = {};
   local v9 = {};
   local v10 = {};
   local v11 = {};
   local v12 = {};
   v12.raycastwhitelist = {};
   local v13 = {};
   shared.add("hud", v7);
   shared.add("char", v5);
   shared.add("roundsystem", v12);
   shared.add("replication", v10);
   local v14 = shared.require("PublicSettings");
   local v15 = shared.require("RenderSteppedRunner");
   local v16 = shared.require("HeartbeatRunner");
   local v17 = shared.require("network");
   local v18 = v17;
   local v19 = shared.require("trash");
   local v20 = v19;
   local v21 = shared.require("vector");
   local v22 = shared.require("cframe");
   local v23 = v22;
   local v24 = shared.require("spring");
   local v25 = v24;
   local v26 = shared.require("Event");
   local v27 = shared.require("ScreenCull");
   local v28 = v27;
   local v29 = shared.require("camera");
   local v30 = v29;
   local v31 = shared.require("sequencer");
   local v32 = shared.require("animation");
   local v33 = shared.require("input");
   local v34 = shared.require("particle");
   local v35 = shared.require("effects");
   local v36 = shared.require("tween");
   local v37 = shared.require("uiscaler");
   local v38 = v37;
   local v39 = shared.require("InstanceType");
   local v40 = v39;
   local v41 = shared.require("sound");
   local v42 = shared.require("ModifyData");
   local v43 = shared.require("GunDataGetter");
   local u1 = v43;
   local u2 = v1;
   local f_gunrequire;
   f_gunrequire = function(p1)
      --[[
         Name: gunrequire
         Upvalues: 
            1 => u1
            2 => u2
   
      --]]
      local v44 = u1.getGunModule(p1);
      local v45 = v44;
      if (not v44) then
         return;
      end
      if (u2) then
         return require(v45:Clone());
      end
      return require(v45);
   end;
   local t_getGunModel_3 = v43.getGunModel;
   print("Loading data module");
   local v46 = string.sub;
   local v47 = string.find;
   local v48 = table.concat;
   local u3 = {};
   local u4 = v4;
   v17:add("loadplayerdata", function(p2)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
            2 => u4
   
      --]]
      u3 = p2;
      u4.loaded = true;
   end);
   v17:add("updateplayerdata", function(p3, ...)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      local v49 = {...};
      local v50 = v49;
      local v51 = u3;
      local v52 = 1;
      local v53 = (#v49) - 1;
      local v54 = v53;
      local v55 = v52;
      if (not (v53 <= v55)) then
         while true do
            if (not v51[v50[v52]]) then
               v51[v50[v52]] = {};
            end
            v51 = v51[v50[v52]];
            local v56 = v52 + 1;
            v52 = v56;
            local v57 = v54;
            if (v57 < v56) then
               break;
            end
         end
      end
      v51[v50[#v50]] = p3;
   end);
   local u5 = v11;
   v17:add("updateinventorydata", function(p4)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
            2 => u5
   
      --]]
      if (not u3.settings) then
         u3.settings = {};
      end
      u3.settings.inventorydata = p4;
      if (u5.updateinventorydata) then
         u5.updateinventorydata(u3.settings.inventorydata);
      end
   end);
   v17:add("updatepitydata", function(p5)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      u3.settings.pitydata = p5;
   end);
   v17:add("updateunlocksdata", function(p6)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      u3.unlocks = p6;
   end);
   v17:add("updateexperience", function(p7)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      u3.stats.experience = p7;
   end);
   v17:add("updatetotalkills", function(p8)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      u3.stats.totalkills = p8;
   end);
   v17:add("updatetotaldeaths", function(p9)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      u3.stats.totaldeaths = p9;
   end);
   v17:add("updategunkills", function(p10, p11)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u3
   
      --]]
      local v58 = u3.unlocks[p10];
      if (not v58) then
         v58 = {};
         u3.unlocks[p10] = v58;
      end
      v58.kills = p11;
   end);
   local f_getdata;
   f_getdata = function()
      --[[
         Name: getdata
         Upvalues: 
            1 => u3
   
      --]]
      return u3;
   end;
   v4.getdata = f_getdata;
   local u6 = v4;
   local f_getattloadoutdata;
   f_getattloadoutdata = function()
      --[[
         Name: getattloadoutdata
         Upvalues: 
            1 => u6
            2 => u3
   
      --]]
      local v59 = u6.getdata().settings.attloadoutdata;
      if (not v59) then
         v59 = {};
         u3.settings.attloadoutdata = v59;
      end
      return v59;
   end;
   local f_getattloadoutdata = f_getattloadoutdata;
   local f_getgunattdata;
   f_getgunattdata = function(p12)
      --[[
         Name: getgunattdata
         Upvalues: 
            1 => f_getattloadoutdata
   
      --]]
      local v60 = f_getattloadoutdata();
      local v61 = v60;
      local v62 = v60[p12];
      if (not v62) then
         v62 = {};
         v61[p12] = v62;
      end
      return v62;
   end;
   local f_getgunattdata = f_getgunattdata;
   local f_getattachdata;
   f_getattachdata = function(p13, p14)
      --[[
         Name: getattachdata
         Upvalues: 
            1 => f_getgunattdata
   
      --]]
      if (not p14) then
         return;
      end
      local v63 = f_getgunattdata(p13);
      local v64 = v63;
      local v65 = v63[p14];
      if (not v65) then
         v65 = {};
         v64[p14] = v65;
      end
      return v65;
   end;
   local f_getattachdata = f_getattachdata;
   v17:add("updateattachkills", function(p15, p16, p17)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getattachdata
   
      --]]
      if (p16) then
         f_getattachdata(p15, p16).kills = p17;
      end
   end);
   v4.getattloadoutdata = f_getattloadoutdata;
   v4.getgunattdata = f_getgunattdata;
   v4.getattachdata = f_getattachdata;
   local u7 = v17;
   local f_updatesettings;
   f_updatesettings = function(p18)
      --[[
         Name: updatesettings
         Upvalues: 
            1 => u7
   
      --]]
      u7:send("updatesettings", p18);
   end;
   v4.updatesettings = f_updatesettings;
   v17:send("loadplayerdata");
   print("Loading chat module");
   local v66 = v37.getscale;
   local v67 = game.WaitForChild;
   local v68 = game.FindFirstChild;
   local v69 = UDim2.new;
   local v70 = CFrame.new;
   local v71 = Vector3.new;
   local v72 = Color3.new;
   local v73 = Vector3.new().Dot;
   local v74 = Ray.new;
   local v75 = Instance.new;
   local v76 = game.IsA;
   local v77 = string.sub;
   local v78 = string.len;
   local v79 = string.lower;
   local v80 = string.find;
   local v81 = table.insert;
   local v82 = string.match;
   local v83 = v39.GetString();
   local v84 = game:GetService("Players").LocalPlayer;
   local v85 = v84.PlayerGui;
   local v86 = v67(game.ReplicatedStorage.Misc, "MsgerMain");
   local v87 = v67(v85, "ChatGame");
   local v88 = v67(v87, "TextBox");
   local v89 = v67(v87, "Warn");
   local v90 = v67(v87, "Version");
   local v91 = v67(v87, "GlobalChat");
   local v92 = v39.IsVIP();
   local u8 = 0;
   local u9 = 0;
   local u10 = v90;
   local u11 = t_Value_1;
   local u12 = v83;
   local f_updateversionstr;
   f_updateversionstr = function(p19)
      --[[
         Name: updateversionstr
         Upvalues: 
            1 => u10
            2 => u11
            3 => u12
   
      --]]
      u10.Text = string.format("<b>Version: %s-%s#%s</b>", u11, string.lower(u12), p19 or "N/A");
   end;
   v6.updateversionstr = f_updateversionstr;
   local t_getscale_4 = v66;
   local u13 = v86;
   local t_WaitForChild_5 = v67;
   local u14 = v91;
   local u15 = v69;
   v17:add("console", function(p20)
      --[[
         Name: (empty)
         Upvalues: 
            1 => t_getscale_4
            2 => u13
            3 => t_WaitForChild_5
            4 => u14
            5 => u15
   
      --]]
      local v93 = t_getscale_4();
      local v94 = u13:Clone();
      local v95 = t_WaitForChild_5(v94, "Tag");
      v94.Text = "[Console]: ";
      v94.TextColor3 = Color3.new(0.4, 0.4, 0.4);
      v94.Msg.Text = p20;
      v94.Parent = u14;
      v94.Msg.Position = u15(0, v94.TextBounds.x / v93, 0, 0);
   end);
   local t_getscale_6 = v66;
   local u16 = v86;
   local t_WaitForChild_7 = v67;
   local u17 = v91;
   local u18 = v69;
   v17:add("announce", function(p21)
      --[[
         Name: (empty)
         Upvalues: 
            1 => t_getscale_6
            2 => u16
            3 => t_WaitForChild_7
            4 => u17
            5 => u18
   
      --]]
      local v96 = t_getscale_6();
      local v97 = u16:Clone();
      local v98 = t_WaitForChild_7(v97, "Tag");
      v97.Text = "[ANNOUNCEMENT]: ";
      v97.TextColor3 = Color3.new(0.9803921568627451, 0.6509803921568628, 0.1019607843137255);
      v97.Msg.Text = p21;
      v97.Parent = u17;
      v97.Msg.Position = u18(0, v97.TextBounds.x / v96, 0, 0);
   end);
   local t_getscale_8 = v66;
   local u19 = v86;
   local t_WaitForChild_9 = v67;
   local u20 = v91;
   local u21 = v69;
   v17:add("chatted", function(p22, p23, p24, p25, p26)
      --[[
         Name: (empty)
         Upvalues: 
            1 => t_getscale_8
            2 => u19
            3 => t_WaitForChild_9
            4 => u20
            5 => u21
   
      --]]
      local v99 = false;
      local v100 = t_getscale_8();
      local v101 = u19:Clone();
      local v102 = v101;
      local v103 = t_WaitForChild_9(v101, "Tag");
      v101.Parent = u20;
      local v104;
      if (p24) then
         v104 = p24 .. " ";
         if (not v104) then
            v99 = true;
         end
      else
         v99 = true;
      end
      if (v99) then
         v104 = "";
      end
      v103.Text = v104;
      if (p24) then
         local v105 = string.sub(p24, 0, 1);
         if (v105 == "$") then
            local v106 = string.sub(p24, 2);
            v102.Position = u21(0.01, 50, 1, 20);
            v103.Staff.Visible = true;
            v103.Staff.Image = "rbxassetid://" .. v106;
            v103.Text = "    ";
         else
            local v107 = (v103.TextBounds.x / v100) + 5;
            v102.Position = u21(0.01, v107, 1, 20);
            v103.Position = u21(0, (-v107) + 5, 0, 0);
            if (p25) then
               v103.TextColor3 = p25;
            end
         end
      end
      v102.Text = p22.Name .. " : ";
      v102.TextColor = p22.TeamColor;
      v102.Msg.Text = p23;
      if (p26) then
         v102.Msg.TextColor3 = Color3.new(1, 0, 0);
      end
      v102.Msg.Position = u21(0, v102.TextBounds.x / v100, 0, 0);
   end);
   local g_math_10 = math;
   local v108 = string.byte;
   local v109 = string.find;
   local v110 = v108("(");
   local v111 = v108(")");
   local v112 = v108("+");
   local v113 = v108("-");
   local v114 = v108("*");
   local v115 = v108("/");
   local v116 = v108("^");
   local v117 = v108("%");
   local v118 = v108("0");
   local v119 = v108("9");
   local v120 = v108(".");
   local v121 = v108(" ");
   local v122 = v108("	");
   local v123 = v108("\n");
   local v124 = {};
   v124[v112] = function(p27, p28)
      --[[
         Name: (empty)
      --]]
      return p27 + p28;
   end;
   v124[v113] = function(p29, p30)
      --[[
         Name: (empty)
      --]]
      return p29 - p30;
   end;
   v124[v114] = function(p31, p32)
      --[[
         Name: (empty)
      --]]
      return p31 * p32;
   end;
   v124[v115] = function(p33, p34)
      --[[
         Name: (empty)
      --]]
      return p33 / p34;
   end;
   v124[v116] = function(p35, p36)
      --[[
         Name: (empty)
      --]]
      return p35 ^ p36;
   end;
   v124[v117] = function(p37, p38)
      --[[
         Name: (empty)
      --]]
      return p37 % p38;
   end;
   local v125 = {};
   v125[v121] = true;
   v125[v122] = true;
   v125[v123] = true;
   local u22 = v112;
   local u23 = v108;
   local u24 = v124;
   local u25 = v111;
   local u26 = v125;
   local u27 = v110;
   local u28 = true;
   local u29 = v118;
   local u30 = v119;
   local u31 = v120;
   local u32 = v109;
   local g_math_11 = g_math_10;
   local f_f;
   f_f = function(p39, p40)
      --[[
         Name: f
         Upvalues: 
            1 => u22
            2 => u23
            3 => u24
            4 => u25
            5 => u26
            6 => u27
            7 => u28
            8 => u29
            9 => u30
            10 => u31
            11 => u32
            12 => g_math_11
   
      --]]
      local v126 = #p39;
      local v127 = 0;
      local v128 = u22;
      while true do
         if (p40 <= v126) then
            local v129 = u23(p39, p40);
            local v130 = v129;
            if (u24[v129]) then
               v128 = v130;
            else
               local v131 = u25;
               if (v130 ~= v131) then
                  if (not u26[v130]) then
                     local v132 = false;
                     local v133 = u27;
                     local v136;
                     if (v130 == v133) then
                        local v134, v135 = u28(p39, p40 + 1);
                        v136 = v134;
                        p40 = v135;
                        v132 = true;
                     else
                        local v137 = false;
                        local v138 = false;
                        if (u29 <= v130) then
                           local v139 = u30;
                           if (v130 <= v139) then
                              v138 = true;
                           else
                              v137 = true;
                           end
                        else
                           v137 = true;
                        end
                        if (v137) then
                           local v140 = u31;
                           if (v130 == v140) then
                              v138 = true;
                           else
                              local v141, v142, v143 = u32(p39, "(%a*)%(", p40);
                              p40 = v142;
                              local v144 = v143;
                              if (p40) then
                                 local v145, v146 = u28(p39, p40 + 1);
                                 p40 = v146;
                                 v136 = g_math_11[v144](v145);
                                 v132 = true;
                              else
                                 return;
                              end
                           end
                        end
                        if (v138) then
                           local v147, v148, v149 = u32(p39, "(%d*%.?%d*)", p40);
                           p40 = v148;
                           v136 = v149;
                           v132 = true;
                        end
                     end
                     if (v132) then
                        v127 = u24[v128](v127, v136);
                     end
                  end
               end
            end
            p40 = p40 + 1;
            continue;
         end
         return v127, p40;
      end
   end;
   local f_f = f_f;
   local f_eval;
   f_eval = function(p41)
      --[[
         Name: eval
         Upvalues: 
            1 => f_f
   
      --]]
      return f_f(p41, 1);
   end;
   local u33 = v79;
   local u34 = v81;
   local u35 = v77;
   local u36 = v80;
   local f_findplayer;
   f_findplayer = function(p42, p43)
      --[[
         Name: findplayer
         Upvalues: 
            1 => u33
            2 => u34
            3 => u35
            4 => u36
   
      --]]
      local v150 = u33(p42);
      if (v150 == "all") then
         local v151 = {};
         local v152 = game:GetService("Players"):GetPlayers();
         local v153 = v152;
         local v154 = 1;
         local v155 = #v152;
         local v156 = v155;
         local v157 = v154;
         if (not (v155 <= v157)) then
            while true do
               u34(v151, v153[v154]);
               local v158 = v154 + 1;
               v154 = v158;
               local v159 = v156;
               if (v159 < v158) then
                  break;
               end
            end
         end
         return v151;
      end
      local v160 = u33(p42);
      if (v160 == "me") then
         return {
            p43
         };
      end
      local v161 = u33(p42);
      if (v161 == "others") then
         local v162 = {};
         local v163 = game:GetService("Players"):GetPlayers();
         local v164 = v163;
         local v165 = 1;
         local v166 = #v163;
         local v167 = v166;
         local v168 = v165;
         if (not (v166 <= v168)) then
            while true do
               if (v164 ~= p43) then
                  u34(v162, v164[v165]);
               end
               local v169 = v165 + 1;
               v165 = v169;
               local v170 = v167;
               if (v170 < v169) then
                  break;
               end
            end
         end
         return v162;
      end
      local v171 = {};
      local v172 = {};
      local v173 = 0;
      local v174 = 1;
      local v175 = nil;
      while true do
         v173 = v173 + 1;
         local v176 = u35(p42, v173, v173);
         if (v176 == "") then
            break;
         end
         local v177 = string.sub(p42, v173, v173);
         if (v177 == ",") then
            v175 = true;
            table.insert(v172, v174);
            table.insert(v172, v173);
            v174 = v173 + 1;
         end
      end
      u34(v172, v174);
      u34(v172, v173 - 1);
      local v178 = v173 - 1;
      if (v175) then
         local v179 = 1;
         local v180 = #v172;
         local v181 = v180;
         local v182 = v179;
         if (not (v180 <= v182)) then
            while true do
               local v183 = false;
               local v184 = 0;
               local v185 = nil;
               local v186 = game:GetService("Players"):GetPlayers();
               local v187 = v186;
               local v188 = 1;
               local v189 = #v186;
               local v190 = v189;
               local v191 = v188;
               if (v189 <= v191) then
                  v183 = true;
               else
                  while true do
                     local v192 = u36(u33(v187[v188].Name), u35(u33(p42), v172[v179], v172[v179 + 1] - 1));
                     if (v192 == 1) then
                        v185 = v187[v188];
                        v184 = v184 + 1;
                     end
                     local v193 = v188 + 1;
                     v188 = v193;
                     local v194 = v190;
                     if (v194 < v193) then
                        break;
                     end
                  end
                  v183 = true;
               end
               if (v183) then
                  if (v184 == 1) then
                     table.insert(v171, v185);
                  end
                  local v195 = v179 + 2;
                  v179 = v195;
                  local v196 = v181;
                  if (v196 < v195) then
                     break;
                  end
               end
            end
         end
         local v197 = false;
         local v198 = #v171;
         local v199;
         if (v198 == 0) then
            v197 = true;
         else
            v199 = v171;
            if (not v199) then
               v197 = true;
            end
         end
         if (v197) then
            v199 = 0;
         end
         return v199;
      end
      local v200 = 0;
      local v201 = nil;
      local v202 = game:GetService("Players"):GetPlayers();
      local v203 = v202;
      local v204 = 1;
      local v205 = #v202;
      local v206 = v205;
      local v207 = v204;
      if (not (v205 <= v207)) then
         while true do
            local v208 = u36(u33(v203[v204].Name), u33(p42));
            if (v208 == 1) then
               v201 = {
                  v203[v204]
               };
               v200 = v200 + 1;
            end
            local v209 = v204 + 1;
            v204 = v209;
            local v210 = v206;
            if (v210 < v209) then
               break;
            end
         end
      end
      local v211 = false;
      local v212;
      if (v200 == 1) then
         v212 = v201;
         if (not v212) then
            v211 = true;
         end
      else
         v211 = true;
      end
      if (v211) then
         v212 = 0;
      end
      return v212;
   end;
   v17:add("printstring", function(...)
      --[[
         Name: (empty)
      --]]
      local v213 = {...};
      local v214 = "";
      local v215 = 1;
      local v216 = #v214;
      local v217 = v216;
      local v218 = v215;
      if (not (v216 <= v218)) then
         while true do
            v214 = v214 .. ("	" .. v213[v215]);
            local v219 = v215 + 1;
            v215 = v219;
            local v220 = v217;
            if (v220 < v219) then
               break;
            end
         end
      end
      local v221 = v214 .. "\n";
      local v222 = 0;
      local v223 = "";
      local v224, v225, v226 = string.gmatch(v221, "(^[\n]*)\n");
      local v227 = v224;
      local v228 = v225;
      local v229 = v226;
      while true do
         local v230 = v227(v228, v229);
         local v231 = v230;
         if (v230) then
            break;
         end
         v229 = v231;
         v222 = v222 + 1;
         v223 = v223 .. ("\n" .. v231);
         if (v222 == 64) then
            print(v223);
            v222 = 0;
            v223 = "";
         end
      end
   end);
   local u37 = v88;
   local u38 = v77;
   local u39 = v17;
   local u40 = v78;
   local u41 = v89;
   local t_LocalPlayer_12 = v84;
   local f_newchat;
   f_newchat = function()
      --[[
         Name: newchat
         Upvalues: 
            1 => u37
            2 => u38
            3 => u39
            4 => u40
            5 => f_eval
            6 => u8
            7 => u41
            8 => u9
            9 => t_LocalPlayer_12
   
      --]]
      local v232 = u37.Text;
      u37.Text = "Press '/' or click here to chat";
      u37.ClearTextOnFocus = true;
      u37.Active = false;
      local v233 = u38(v232, 1, 1);
      if (v233 == "/") then
         u39:send("modcmd", v232);
         u37.Text = "Press '/' or click here to chat";
         u37.ClearTextOnFocus = true;
         return;
      end
      local v234 = nil;
      local v235 = u38(v232, 1, 1);
      if (v235 == "%") then
         v234 = true;
         v232 = u38(v232, 2, u40(v232));
      end
      local v236 = string.gsub(v232, "{(.-)}", f_eval);
      local v237 = u8;
      if (not (v237 > 5)) then
         local v238 = u40(v236);
         if (v238 > 256) then
            v236 = u38(v236, 1, 256);
         end
         u8 = u8 + 1;
         u39:send("chatted", v236, v234);
         delay(10, function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u8
   
            --]]
            u8 = u8 - 1;
         end);
         return;
      end
      u41.Visible = true;
      u8 = u8 + 1;
      u9 = u9 + 1;
      u41.Text = "You have been blocked temporarily for spamming.   WARNING : " .. (u9 .. " out of 3");
      local v239 = u9;
      if (v239 > 3) then
         t_LocalPlayer_12:Kick("Kicked for repeated spamming");
      end
      delay(5, function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u8
               2 => u41
   
         --]]
         u8 = u8 - 5;
         u41.Visible = false;
      end);
   end;
   local u42 = v91;
   local u43 = v88;
   local f_hidechat;
   f_hidechat = function(p44, p45)
      --[[
         Name: hidechat
         Upvalues: 
            1 => u42
            2 => u43
   
      --]]
      u42.Visible = not p45;
      u43.Visible = not p45;
   end;
   v6.hidechat = f_hidechat;
   local u44 = v91;
   local u45 = v69;
   local u46 = v88;
   local f_inmenu;
   f_inmenu = function(p46)
      --[[
         Name: inmenu
         Upvalues: 
            1 => u44
            2 => u45
            3 => u46
   
      --]]
      u44.Position = u45(0, 20, 1, -100);
      u46.Position = u45(0, 10, 1, -20);
   end;
   v6.inmenu = f_inmenu;
   local u47 = v91;
   local u48 = v69;
   local u49 = v88;
   local f_ingame;
   f_ingame = function(p47)
      --[[
         Name: ingame
         Upvalues: 
            1 => u47
            2 => u48
            3 => u49
   
      --]]
      u47.Position = u48(0, 150, 1, -50);
      u49.Position = u48(0, 10, 1, -20);
   end;
   v6.ingame = f_ingame;
   local v240 = v91.ChildAdded;
   local t_getscale_13 = v66;
   local u50 = v91;
   local t_WaitForChild_14 = v67;
   local u51 = v69;
   local t_FindFirstChild_15 = v68;
   v240:connect(function(p48)
      --[[
         Name: (empty)
         Upvalues: 
            1 => t_getscale_13
            2 => u50
            3 => t_WaitForChild_14
            4 => u51
            5 => t_FindFirstChild_15
   
      --]]
      wait();
      local v241 = t_getscale_13();
      local v242 = u50:GetChildren();
      local v243 = v242;
      local v244 = 1;
      local v245 = #v242;
      local v246 = v245;
      local v247 = v244;
      if (not (v245 <= v247)) then
         while true do
            local v248 = v243[v244];
            local v249 = v248;
            local v250 = t_WaitForChild_14(v248, "Tag");
            local v251 = v250;
            local v252 = 20;
            local t_Text_16 = v250.Text;
            if (t_Text_16 ~= "") then
               v252 = 20 + (v251.TextBounds.x / v241);
               v249.Position = u51(0, v252, 1, v249.Position.Y.Offset);
            end
            if (v249.Parent) then
               v249:TweenPosition(u51(0, v252, 1, (v244 - (#v243)) * 20), "Out", "Sine", 0.2, true);
            end
            local v253 = #v243;
            if (v253 > 8) then
               local v254 = (#v243) - 8;
               if (v244 <= v254) then
                  local t_Name_17 = v249.Name;
                  if (t_Name_17 ~= "Deleted") then
                     v249.Name = "Deleted";
                     t_WaitForChild_14(v249, "Msg");
                     t_WaitForChild_14(v249, "Tag");
                     local v255 = 1;
                     local v256 = v255;
                     if (not (v256 >= 5)) then
                        while true do
                           if (t_FindFirstChild_15(v249, "Msg") and t_FindFirstChild_15(v249, "Tag")) then
                              v249.TextTransparency = (v255 * 2) / 10;
                              v249.TextStrokeTransparency = ((v255 * 2) / 10) + 0.1;
                              v249.Msg.TextTransparency = (v255 * 2) / 10;
                              v249.Msg.TextStrokeTransparency = ((v255 * 2) / 10) + 0.1;
                              v249.Tag.TextTransparency = (v255 * 2) / 10;
                              v249.Tag.TextStrokeTransparency = ((v255 * 2) / 10) + 0.1;
                              wait(0.03333333333333333);
                           end
                           if (v249 and v249.Parent) then
                              v249:Destroy();
                           end
                           local v257 = v255 + 1;
                           v255 = v257;
                           if (v257 > 5) then
                              break;
                           end
                        end
                     end
                  end
               end
            end
            local v258 = v244 + 1;
            v244 = v258;
            local v259 = v246;
            if (v259 < v258) then
               break;
            end
         end
      end
   end);
   local v260 = v88.Focused;
   local u52 = v88;
   v260:connect(function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => u52
   
      --]]
      u52.Active = true;
   end);
   local v261 = v88.FocusLost;
   local u53 = v88;
   local f_newchat = f_newchat;
   v261:connect(function(p49)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u53
            2 => f_newchat
   
      --]]
      u53.Active = false;
      if (p49) then
         local t_Text_18 = u53.Text;
         if (t_Text_18 ~= "") then
            f_newchat();
         end
      end
   end);
   local v262 = game:GetService("UserInputService").InputBegan;
   local u54 = v89;
   local u55 = v88;
   local u56 = v7;
   v262:connect(function(p50)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u54
            2 => u55
            3 => u56
   
      --]]
      if (u54.Visible) then
         return;
      end
      local t_KeyCode_19 = p50.KeyCode;
      if (not u55.Active) then
         local v263 = Enum.KeyCode.Slash;
         if (t_KeyCode_19 == v263) then
            wait(0.03333333333333333);
            u55:CaptureFocus();
            u55.ClearTextOnFocus = false;
            return;
         end
         local v264 = Enum.KeyCode[u56.voteyes];
         if (t_KeyCode_19 == v264) then
            u56:vote("yes");
            return;
         end
         local v265 = Enum.KeyCode[u56.votedismiss];
         if (t_KeyCode_19 == v265) then
            u56:vote("dismiss");
            return;
         end
         local v266 = Enum.KeyCode[u56.voteno];
         if (t_KeyCode_19 == v266) then
            u56:vote("no");
         end
      end
   end);
   v6.updateversionstr();
   print("Loading hud module");
   local v267 = v37.getscale;
   local v268 = game.WaitForChild;
   local t_WaitForChild_20 = v268;
   local v269 = game.FindFirstChild;
   local t_FindFirstChild_21 = v269;
   local v270 = UDim2.new;
   local v271 = v270;
   local v272 = CFrame.new;
   local v273 = v272;
   local v274 = Vector3.new;
   local v275 = v274;
   local v276 = Color3.new;
   local v277 = v276;
   local v278 = Vector3.new().Dot;
   local t_Dot_22 = v278;
   local v279 = Ray.new;
   local v280 = v279;
   local v281 = Instance.new;
   local v282 = v281;
   local v283 = game.IsA;
   local v284 = game.Debris;
   local v285 = game:GetService("Players").LocalPlayer;
   local t_LocalPlayer_23 = v285;
   local v286 = game.ReplicatedStorage.Character.PlayerTag;
   local v287 = v285.PlayerGui;
   local v288 = game.ReplicatedStorage;
   local t_ReplicatedStorage_24 = v288;
   local v289 = v288.Misc;
   local t_BloodArc_25 = v289.BloodArc;
   local v290 = v289.Spot;
   local v291 = v289.Feed;
   local v292 = v289.Headshot;
   local v293 = v268(v287, "MainGui");
   local v294 = v293;
   local v295 = v268(v293, "GameGui");
   local v296 = v295;
   local v297 = v268(v295, "CrossHud");
   local v298 = v268(v297, "Sprint");
   local v299 = {
      v268(v297, "HR"),
      v268(v297, "HL"),
      v268(v297, "VD"),
      v268(v297, "VU")
   };
   local v300 = v268(v295, "AmmoHud");
   local v301 = v268(v293, "ScopeFrame");
   local v302 = v301;
   local v303 = v268(v295, "Hitmarker");
   local v304 = v303;
   local v305 = v268(v295, "NameTag");
   local v306 = v268(v295, "Capping");
   local v307 = v306;
   local v308 = v268(v295, "BloodScreen");
   local v309 = v268(v295, "Radar");
   local v310 = v268(v295, "Killfeed");
   local v311 = v268(v295, "Steady");
   local v312 = v311;
   local v313 = v268(v295, "Use");
   local v314 = v268(v295, "Round");
   local v315 = v268(v295, "Spotted");
   local v316 = v268(v287.ChatGame, "GlobalChat");
   local v317 = v268(v268(v311, "Full"), "Bar");
   local v318 = v268(v309, "Me");
   local v319 = v268(v309, "Folder");
   local v320 = (-v318.Size.X.Offset) / 2;
   local v321 = v268(v300, "Frame");
   local v322 = v268(v321, "Ammo");
   local v323 = v268(v321, "GAmmo");
   local v324 = v268(v321, "Mag");
   local v325 = v268(v321, "Health");
   local v326 = v268(v321, "FMode");
   local v327 = v268(v321, "healthbar_back");
   local v328 = v327;
   local v329 = v268(v327, "healthbar_fill");
   local v330 = {
      Color3.new(0.1490196078431373, 0.3137254901960784, 0.2784313725490196),
      Color3.new(0.1764705882352941, 0.5019607843137255, 0.4313725490196079),
      Color3.new(0.8745098039215686, 0.1215686274509804, 0.1215686274509804),
      Color3.new(0.5333333333333333, 0.06666666666666667, 0.06666666666666667)
   };
   local v331 = v268(v306, "Percent");
   local u57 = nil;
   local u58 = nil;
   local u59 = nil;
   local v332 = {};
   local v333 = {};
   local v334 = {};
   local v335 = {};
   local u60 = 0;
   local u61 = 0;
   local u62 = 0;
   local v336 = {};
   local v337 = {};
   v337.gui = v300;
   v337.enabled = true;
   v336.ammohud = v337;
   local v338 = {};
   v338.gui = v309;
   v338.enabled = true;
   v336.radar = v338;
   local v339 = {};
   v339.gui = v310;
   v339.enabled = true;
   v336.killfeed = v339;
   local v340 = {};
   v340.gui = v297;
   v340.enabled = true;
   v336.crossframe = v340;
   local v341 = {};
   v341.gui = v314;
   v341.enabled = true;
   v336.round = v341;
   v7.crossscale = v24.new(0);
   v7.crossscale.s = 10;
   v7.crossscale.d = 0.8;
   v7.crossscale.t = 1;
   v7.crossspring = v24.new(0);
   v7.crossspring.s = 12;
   v7.crossspring.d = 0.65;
   v7.hitspring = v24.new(1);
   v7.hitspring.s = 5;
   v7.hitspring.d = 0.7;
   local v342 = v268(v287.ChatGame, "Votekick");
   local v343 = v268(v342, "Title");
   local v344 = v268(v342, "Timer");
   local v345 = v268(v342, "Votes");
   local v346 = v268(v342, "Yes");
   local v347 = v268(v342, "No");
   local v348 = v268(v342, "Dismiss");
   local v349 = v268(v342, "Choice");
   local u63 = 0;
   local u64 = 0;
   local u65 = 0;
   local u66 = nil;
   local u67 = nil;
   v7.voteyes = "Y";
   v7.voteno = "N";
   v7.votedismiss = "J";
   v346.Text = "Yes [" .. (string.upper(v7.voteyes) .. "]");
   v347.Text = "No [" .. (string.upper(v7.voteno) .. "]");
   v348.Text = "Dismiss [" .. (string.upper(v7.votedismiss) .. "]");
   local u68 = v7;
   local u69 = v342;
   local u70 = v344;
   local u71 = v345;
   local f_votestep;
   f_votestep = function()
      --[[
         Name: votestep
         Upvalues: 
            1 => u68
            2 => u66
            3 => u69
            4 => u70
            5 => u65
            6 => u71
            7 => u64
            8 => u63
   
      --]]
      if ((not u68.disablevotekick) and u66) then
         u69.Visible = true;
         u70.Text = "Time left: 0:" .. string.format("%.2d", (u65 - tick()) % 60);
         u71.Text = "Votes: " .. (u64 .. (" out of " .. (u63 .. " required")));
         local v350 = u65;
         local v351 = tick();
         if (not (v350 <= v351)) then
            local v352 = u64;
            if (u63 <= v352) then
            end
         end
         u66 = false;
         u69.Visible = false;
         return;
      end
      u69.Visible = false;
   end;
   v7.votestep = f_votestep;
   local u72 = v346;
   local u73 = v347;
   local u74 = v348;
   local u75 = v349;
   local u76 = v342;
   local u77 = v17;
   local f_vote;
   f_vote = function(p51, p52)
      --[[
         Name: vote
         Upvalues: 
            1 => u66
            2 => u67
            3 => u72
            4 => u73
            5 => u74
            6 => u75
            7 => u76
            8 => u77
   
      --]]
      if (u66 and (not u67)) then
         u72.Visible = false;
         u73.Visible = false;
         u74.Visible = false;
         u75.Visible = true;
         u67 = true;
         if (p52 == "yes") then
            u75.Text = "Voted Yes";
            u75.TextColor3 = u72.TextColor3;
         else
            if (p52 == "dismiss") then
               u75.Text = "Vote Dismissed";
               u75.TextColor3 = u74.TextColor3;
               u66 = false;
               u76.Visible = false;
            else
               u75.Text = "Voted No";
               u75.TextColor3 = u73.TextColor3;
            end
         end
         u77:send("votefromUI", p52);
      end
   end;
   v7.vote = f_vote;
   local u78 = v7;
   local u79 = v343;
   local u80 = v342;
   local u81 = v346;
   local u82 = v347;
   local u83 = v348;
   local u84 = v349;
   v17:add("startvotekick", function(p53, p54, p55)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u78
            2 => u79
            3 => u80
            4 => u81
            5 => u82
            6 => u83
            7 => u84
            8 => u63
            9 => u64
            10 => u65
            11 => u66
            12 => u67
   
      --]]
      if (not u78.disablevotekick) then
         u79.Text = "Votekick " .. (p53 .. " out of the server?");
         u80.Visible = true;
         u81.Visible = true;
         u82.Visible = true;
         u83.Visible = true;
         u84.Visible = false;
         u63 = p55;
         u64 = 0;
         u65 = tick() + p54;
         u66 = true;
         u67 = false;
         u78.votestep();
      end
   end);
   v17:add("updatenumvotes", function(p56)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u64
   
      --]]
      u64 = p56;
   end);
   local u85 = v333;
   local f_gethealthstate;
   f_gethealthstate = function(p57)
      --[[
         Name: gethealthstate
         Upvalues: 
            1 => u85
   
      --]]
      local v353 = u85[p57];
      if (not v353) then
         local v354 = {};
         v354.health0 = 0;
         v354.healtick0 = 0;
         v354.alive = false;
         v354.healrate = 0.25;
         v354.maxhealth = 100;
         v354.healwait = 8;
         v353 = v354;
         u85[p57] = v353;
      end
      return v353;
   end;
   local f_gethealthstate = f_gethealthstate;
   local f_updatehealth;
   f_updatehealth = function(p58, p59)
      --[[
         Name: updatehealth
         Upvalues: 
            1 => f_gethealthstate
   
      --]]
      local v355 = f_gethealthstate(p58);
      v355.alive = p59.alive;
      v355.health0 = p59.health0;
      v355.healtick0 = p59.healtick0;
   end;
   v7.updatehealth = f_updatehealth;
   local f_gethealthstate = f_gethealthstate;
   local u86 = v11;
   v17:add("updateothershealth", function(p60, p61, p62, p63)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_gethealthstate
            2 => u86
   
      --]]
      local v356 = f_gethealthstate(p60);
      v356.health0 = p61;
      v356.healtick0 = p62;
      v356.alive = p63;
      if (u86.updatelist) then
         u86.updatelist(p60, "Toggle");
      end
   end);
   local u87 = v336;
   local u88 = v37;
   local t_Feed_26 = v291;
   local u89 = v310;
   local t_Headshot_27 = v292;
   local u90 = v270;
   local t_FindFirstChild_28 = v269;
   v17:add("killfeed", function(p64, p65, p66, p67, p68)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u87
            2 => u88
            3 => t_Feed_26
            4 => u89
            5 => t_Headshot_27
            6 => u90
            7 => t_FindFirstChild_28
   
      --]]
      if (u87.killfeed.enabled) then
         local v357 = u88.getscale();
         local v358 = v357;
         local v359 = t_Feed_26:Clone();
         local v360 = v359;
         v359.Parent = u89;
         v359.Text = p64.Name;
         v359.TextColor = p64.TeamColor;
         v359.GunImg.Text = p67;
         v359.Victim.Text = p65.Name;
         v359.Victim.TextColor = p65.TeamColor;
         v359.GunImg.Dist.Text = "Dist: " .. (p66 .. " studs");
         v359.GunImg.Size = UDim2.new(0, v359.GunImg.TextBounds.x / v357, 0, 30);
         v359.GunImg.Position = UDim2.new(0, 15 + (v359.TextBounds.x / v357), 0, -5);
         v359.Victim.Position = UDim2.new(0, (30 + (v359.TextBounds.x / v357)) + (v359.GunImg.TextBounds.x / v357), 0, 0);
         if (p68) then
            local v361 = t_Headshot_27:Clone();
            v361.Parent = v360.Victim;
            v361.Position = u90(0, 10 + (v360.Victim.TextBounds.x / v358), 0, -5);
         end
         local g_spawn_29 = spawn;
         local u91 = v360;
         g_spawn_29(function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u91
   
            --]]
            u91.Visible = true;
            wait(20);
            local v362 = 1;
            local v363 = v362;
            if (not (v363 >= 10)) then
               while true do
                  if (u91.Parent) then
                     u91.TextTransparency = v362 / 10;
                     u91.TextStrokeTransparency = (v362 / 10) + 0.5;
                     u91.GunImg.TextStrokeTransparency = (v362 / 10) + 0.5;
                     u91.GunImg.TextTransparency = v362 / 10;
                     u91.Victim.TextStrokeTransparency = (v362 / 10) + 0.5;
                     u91.Victim.TextTransparency = v362 / 10;
                     wait(0.03333333333333333);
                  end
                  local v364 = v362 + 1;
                  v362 = v364;
                  if (v364 > 10) then
                     break;
                  end
               end
            end
            if (u91 and u91.Parent) then
               u91:Destroy();
            end
         end);
         local v365 = u89:GetChildren();
         local v366 = v365;
         local v367 = 1;
         local v368 = #v365;
         local v369 = v368;
         local v370 = v367;
         if (not (v368 <= v370)) then
            while true do
               v366[v367]:TweenPosition(u90(0.01, 5, 1, ((v367 - (#v366)) * 25) - 25), "Out", "Sine", 0.2, true);
               local v371 = #v366;
               if (v371 > 5) then
                  local v372 = (#v366) - v367;
                  if (v372 >= 5) then
                     local g_spawn_30 = spawn;
                     local u92 = v366;
                     g_spawn_30(function()
                        --[[
                           Name: (empty)
                           Upvalues: 
                              1 => u92
                              2 => t_FindFirstChild_28
   
                        --]]
                        local v373 = u92[1];
                        local v374 = v373;
                        local t_Name_31 = v373.Name;
                        if (t_Name_31 ~= "Deleted") then
                           local v375 = 1;
                           local v376 = v375;
                           if (not (v376 >= 10)) then
                              while true do
                                 if (t_FindFirstChild_28(v374, "Victim")) then
                                    v374.TextTransparency = v375 / 10;
                                    v374.TextStrokeTransparency = (v375 / 10) + 0.5;
                                    v374.Victim.TextTransparency = v375 / 10;
                                    v374.Victim.TextStrokeTransparency = (v375 / 10) + 0.5;
                                    v374.Name = "Deleted";
                                    v374.GunImg.TextTransparency = v375 / 10;
                                    v374.GunImg.TextStrokeTransparency = (v375 / 10) + 0.5;
                                    wait(0.03333333333333333);
                                 end
                                 local v377 = v375 + 1;
                                 v375 = v377;
                                 if (v377 > 10) then
                                    break;
                                 end
                              end
                           end
                           v374:Destroy();
                        end
                     end);
                  end
               end
               local v378 = v367 + 1;
               v367 = v378;
               local v379 = v369;
               if (v379 < v378) then
                  break;
               end
            end
         end
      end
   end);
   local v380 = math.pi / 180;
   local v381 = CFrame.Angles;
   local v382 = v288.ServerSettings.GameMode;
   local v383 = v288.GamemodeProps.FlagDrop.Base.PointLight;
   local v384 = v288.GamemodeProps.FlagCarry;
   local v385 = v288.GamemodeProps.FlagDrop;
   local v386 = BrickColor.new("Bright blue");
   local v387 = BrickColor.new("Bright orange");
   local v388 = {
      v386,
      v387
   };
   local v389 = v268(v295, "Captured");
   local v390 = v268(v295, "Revealed");
   local v391 = {};
   v391.caplight = nil;
   local v392 = v386.Name;
   local v393 = {};
   v393.revealtime = 0;
   v393.droptime = 0;
   v393.carrier = nil;
   v393.carrymodel = nil;
   v393.dropmodel = nil;
   v393.dropped = false;
   v393.basecf = v272();
   v391[v392] = v393;
   local v394 = v387.Name;
   local v395 = {};
   v395.revealtime = 0;
   v395.droptime = 0;
   v395.carrier = nil;
   v395.carrymodel = nil;
   v395.dropmodel = nil;
   v395.dropped = false;
   v395.basecf = v272();
   v391[v394] = v395;
   local u93 = v391;
   local t_LocalPlayer_32 = v285;
   local f_resetflag;
   f_resetflag = function(p69, p70)
      --[[
         Name: resetflag
         Upvalues: 
            1 => u93
            2 => t_LocalPlayer_32
   
      --]]
      local v396 = u93[p69.Name];
      local v397 = v396;
      v396.revealtime = 0;
      v396.carrier = nil;
      local v398 = t_LocalPlayer_32;
      if (not (((p70 == v398) and u93.caplight) and u93.caplight.Parent)) then
         if (v397.carrymodel and v397.carrymodel.Parent) then
            v397.carrymodel:Destroy();
            v397.carrymodel = nil;
         end
         return;
      end
      u93.caplight:Destroy();
      u93.caplight = nil;
   end;
   local u94 = v388;
   local f_resetflag = f_resetflag;
   local u95 = v391;
   local f_cleanflags;
   f_cleanflags = function()
      --[[
         Name: cleanflags
         Upvalues: 
            1 => u94
            2 => f_resetflag
            3 => u95
   
      --]]
      local g_next_33 = next;
      local v399 = u94;
      local v400 = nil;
      while true do
         local v401, v402 = g_next_33(v399, v400);
         local v403 = v401;
         local v404 = v402;
         if (v401) then
            v400 = v403;
            f_resetflag(v404);
            local v405 = u95[v404.Name];
            local v406 = v405;
            if (v405 and v405.dropmodel) then
               v406.dropmodel:Destroy();
               v406.dropmodel = nil;
            end
         else
            break;
         end
      end
   end;
   local u96 = v391;
   local t_FlagDrop_34 = v385;
   local t_FindFirstChild_35 = v269;
   local t_LocalPlayer_36 = v285;
   local f_dropflag;
   f_dropflag = function(p71, p72, p73, p74)
      --[[
         Name: dropflag
         Upvalues: 
            1 => u96
            2 => t_FlagDrop_34
            3 => t_FindFirstChild_35
            4 => t_LocalPlayer_36
   
      --]]
      local v407 = u96[p71.Name];
      local v408 = v407;
      local v409;
      if (v407.dropmodel and v407.dropmodel.Parent) then
         v409 = v408.dropmodel;
      else
         v409 = t_FlagDrop_34:Clone();
      end
      local v410 = t_FindFirstChild_35(v409, "Base");
      local v411 = v410;
      if (not v410) then
         print("no base", v409);
         return;
      end
      local v412 = t_FindFirstChild_35(v409, "Tag");
      local v413 = t_FindFirstChild_35(v411, "BillboardGui");
      local v414 = v413;
      local v415 = t_FindFirstChild_35(v411, "PointLight");
      v412.BrickColor = p71;
      v409.TeamColor.Value = p71;
      v413.Display.BackgroundColor = p71;
      v415.Color = p71.Color;
      local t_TeamColor_37 = t_LocalPlayer_36.TeamColor;
      if (p71 == t_TeamColor_37) then
         local t_Status_39 = v414.Status;
         local v416;
         if (p74) then
            v416 = "Protect";
         else
            v416 = "Dropped";
         end
         t_Status_39.Text = v416;
      else
         local t_Status_38 = v414.Status;
         local v417;
         if (p74) then
            v417 = "Capture";
         else
            v417 = "Pick Up";
         end
         t_Status_38.Text = v417;
      end
      v409:SetPrimaryPartCFrame(p72);
      v409.Location.Value = p72;
      v409.Parent = workspace.Ignore.GunDrop;
      v408.dropmodel = v409;
      v408.droptime = p73;
      v408.dropped = not p74;
      if (p74) then
         u96[p71.Name].basecf = p72;
      end
   end;
   local u97 = v10;
   local u98 = v386;
   local u99 = v387;
   local t_FlagCarry_40 = v384;
   local u100 = v281;
   local u101 = v391;
   local f_attachflag;
   f_attachflag = function(p75)
      --[[
         Name: attachflag
         Upvalues: 
            1 => u97
            2 => u98
            3 => u99
            4 => t_FlagCarry_40
            5 => u100
            6 => u101
   
      --]]
      if (not ((p75 and p75.Parent) and u97.getbodyparts)) then
         return;
      end
      local v418 = false;
      local v419 = p75.TeamColor;
      local v420 = u98;
      local v421;
      if (v419 == v420) then
         v421 = u99;
         if (not v421) then
            v418 = true;
         end
      else
         v418 = true;
      end
      if (v418) then
         v421 = u98;
      end
      local v422 = u97.getbodyparts(p75);
      local v423 = v422;
      if (v422 and v422.torso) then
         local v424 = t_FlagCarry_40:Clone();
         local v425 = v424;
         v424.Tag.BrickColor = v421;
         v424.Tag.BillboardGui.Display.BackgroundColor3 = v421.Color;
         v424.Tag.BillboardGui.AlwaysOnTop = false;
         v424.Base.PointLight.Color = v421.Color;
         local g_next_41 = next;
         local v426, v427 = v424:GetChildren();
         local v428 = v426;
         local v429 = v427;
         while true do
            local v430, v431 = g_next_41(v428, v429);
            local v432 = v430;
            local v433 = v431;
            if (v430) then
               v429 = v432;
               local t_Base_42 = v425.Base;
               if (v433 ~= t_Base_42) then
                  local v434 = u100("Weld");
                  v434.Part0 = v425.Base;
                  v434.Part1 = v433;
                  v434.C0 = v425.Base.CFrame:inverse() * v433.CFrame;
                  v434.Parent = v425.Base;
               end
               if (v433:IsA("BasePart")) then
                  v433.Massless = true;
                  v433.CastShadow = false;
                  v433.Anchored = false;
                  v433.CanCollide = false;
               end
            else
               break;
            end
         end
         local v435 = u100("Weld");
         v435.Part0 = v423.torso;
         v435.Part1 = v425.Base;
         v435.Parent = v425.Base;
         v425.Parent = workspace.Ignore.Misc;
         u101[v421.Name].carrymodel = v425;
      end
   end;
   local u102 = v386;
   local u103 = v387;
   local u104 = v391;
   local u105 = v7;
   local f_nearenemyflag;
   f_nearenemyflag = function(p76, p77)
      --[[
         Name: nearenemyflag
         Upvalues: 
            1 => u102
            2 => u103
            3 => u104
            4 => u105
   
      --]]
      local v436 = false;
      local v437 = p77.TeamColor;
      local v438 = u102;
      local v439;
      if (v437 == v438) then
         v439 = u103;
         if (not v439) then
            v436 = true;
         end
      else
         v436 = true;
      end
      if (v436) then
         v439 = u102;
      end
      if (u104[v439.Name] and u104[v439.Name].basecf) then
         local v440 = u105:getplayerpos(p77);
         local v441 = v440;
         if (v440 and ((u104[v439.Name].basecf.p - v441).Magnitude < 100)) then
            return true;
         end
      end
      return false;
   end;
   v7.nearenemyflag = f_nearenemyflag;
   local u106 = v389;
   local u107 = v390;
   local t_GameMode_43 = v382;
   local t_LocalPlayer_44 = v285;
   local u108 = v386;
   local u109 = v387;
   local u110 = v391;
   local u111 = v388;
   local f_resetflag = f_resetflag;
   local f_attachflag = f_attachflag;
   local f_gamemodestep;
   f_gamemodestep = function()
      --[[
         Name: gamemodestep
         Upvalues: 
            1 => u106
            2 => u107
            3 => t_GameMode_43
            4 => t_LocalPlayer_44
            5 => u108
            6 => u109
            7 => u110
            8 => u111
            9 => f_resetflag
            10 => f_attachflag
   
      --]]
      u106.Visible = false;
      u107.Visible = false;
      local t_Value_45 = t_GameMode_43.Value;
      if (t_Value_45 == "Capture the Flag") then
         local v442 = false;
         local v443 = t_LocalPlayer_44.TeamColor;
         local v444 = u108;
         local v445;
         if (v443 == v444) then
            v445 = u109;
            if (not v445) then
               v442 = true;
            end
         else
            v442 = true;
         end
         if (v442) then
            v445 = u108;
         end
         local v446 = u110[v445.Name].carrier;
         local v447 = t_LocalPlayer_44;
         if ((v446 == v447) and u110[v445.Name].revealtime) then
            u106.Visible = true;
            u106.Text = "Capturing Enemy Flag!";
            u107.Visible = true;
            local t_revealtime_50 = u110[v445.Name].revealtime;
            if (tick() < t_revealtime_50) then
               u107.Text = "Position revealed in " .. (math.ceil(t_revealtime_50 - tick()) .. " seconds");
            else
               u107.Text = "Flag position revealed to all enemies!";
            end
         end
         local g_next_46 = next;
         local v448 = u111;
         local v449 = nil;
         while true do
            local v450, v451 = g_next_46(v448, v449);
            local v452 = v450;
            local v453 = v451;
            if (v450) then
               v449 = v452;
               local v454 = u110[v453.Name];
               local v455 = v454;
               if (v454.carrier) then
                  local v456 = v455.carrier;
                  local v457 = t_LocalPlayer_44;
                  if (v456 ~= v457) then
                     if (not v455.carrier.Parent) then
                        f_resetflag(v453, nil);
                     end
                     if (not v455.carrymodel) then
                        f_attachflag(v455.carrier);
                     end
                     if ((v455.carrymodel and v455.carrymodel.Parent) and v455.revealtime) then
                        local t_BillboardGui_47 = v455.carrymodel.Tag.BillboardGui;
                        local v458 = t_LocalPlayer_44.TeamColor;
                        local t_TeamColor_48 = v455.carrier.TeamColor;
                        local v459;
                        if (v458 == t_TeamColor_48) then
                           v459 = "Capturing!";
                        else
                           v459 = "Stolen!";
                        end
                        local v460 = true;
                        local v461 = t_LocalPlayer_44.TeamColor;
                        local t_TeamColor_49 = v455.carrier.TeamColor;
                        if (v461 ~= t_TeamColor_49) then
                           v460 = v455.revealtime < tick();
                        end
                        t_BillboardGui_47.AlwaysOnTop = v460;
                        t_BillboardGui_47.Distance.Text = v459;
                     end
                  end
               end
            else
               break;
            end
         end
      end
   end;
   v7.gamemodestep = f_gamemodestep;
   local u112 = 0;
   local t_GameMode_51 = v382;
   local u113 = v272;
   local u114 = v380;
   local u115 = v381;
   local u116 = v391;
   local t_FindFirstChild_52 = v269;
   local t_LocalPlayer_53 = v285;
   local f_gamemoderenderstep;
   f_gamemoderenderstep = function()
      --[[
         Name: gamemoderenderstep
         Upvalues: 
            1 => u112
            2 => t_GameMode_51
            3 => u113
            4 => u114
            5 => u115
            6 => u116
            7 => t_FindFirstChild_52
            8 => t_LocalPlayer_53
   
      --]]
      u112 = u112 + 1;
      local t_Value_54 = t_GameMode_51.Value;
      if (t_Value_54 == "Capture the Flag") then
         local g_next_55 = next;
         local v462, v463 = workspace.Ignore.GunDrop:GetChildren();
         local v464 = v462;
         local v465 = v463;
         while true do
            local v466, v467 = g_next_55(v464, v465);
            local v468 = v466;
            local v469 = v467;
            if (v466) then
               v465 = v468;
               local t_Name_56 = v469.Name;
               if (t_Name_56 == "FlagDrop") then
                  v469:SetPrimaryPartCFrame((v469.Location.Value * u113(0, 0.2 * math.sin((u112 * 5) * u114), 0)) * u115(0, (u112 * 4) * u114, 0));
                  if (u116[v469.TeamColor.Value.Name].dropped) then
                     local v470 = t_FindFirstChild_52(v469.Base, "BillboardGui");
                     local v471 = v470;
                     local v472 = u116[v469.TeamColor.Value.Name].droptime;
                     local t_droptime_57 = v472;
                     if (v470 and v472) then
                        local v473 = t_droptime_57 + 60;
                        if (tick() < v473) then
                           local v474 = math.floor((t_droptime_57 + 60) - tick());
                           local t_Status_58 = v471.Status;
                           local v475 = t_LocalPlayer_53.TeamColor;
                           local t_Value_59 = v469.TeamColor.Value;
                           local v476;
                           if (v475 == t_Value_59) then
                              v476 = "Returning in:";
                           else
                              v476 = "Pick up in: ";
                           end
                           t_Status_58.Text = v476 .. v474;
                        end
                     end
                  end
               end
            else
               break;
            end
         end
      end
   end;
   v7.gamemoderenderstep = f_gamemoderenderstep;
   v7.attachflag = f_attachflag;
   local u117 = v386;
   local u118 = v387;
   local u119 = v391;
   local t_LocalPlayer_60 = v285;
   local u120 = v5;
   local t_PointLight_61 = v383;
   local f_attachflag = f_attachflag;
   v17:add("stealflag", function(p78, p79)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u117
            2 => u118
            3 => u119
            4 => t_LocalPlayer_60
            5 => u120
            6 => t_PointLight_61
            7 => f_attachflag
   
      --]]
      local v477 = false;
      local v478 = p78.TeamColor;
      local v479 = u117;
      local v480;
      if (v478 == v479) then
         v480 = u118;
         if (not v480) then
            v477 = true;
         end
      else
         v477 = true;
      end
      if (v477) then
         v480 = u117;
      end
      u119[v480.Name].revealtime = p79;
      u119[v480.Name].carrier = p78;
      if (u119[v480.Name].dropmodel) then
         u119[v480.Name].dropmodel:Destroy();
         u119[v480.Name].dropmodel = nil;
      end
      local v481 = t_LocalPlayer_60;
      if (not ((p78 == v481) and u120.rootpart)) then
         f_attachflag(p78);
         return;
      end
      u119.caplight = t_PointLight_61:Clone();
      u119.caplight.Color = v480.Color;
      u119.caplight.Parent = u120.rootpart;
   end);
   local u121 = v391;
   local t_FindFirstChild_62 = v269;
   v17:add("updateflagrecover", function(p80, p81, p82)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u121
            2 => t_FindFirstChild_62
   
      --]]
      local v482 = u121[p80.Name];
      local v483 = v482;
      if (v482.dropmodel) then
         local v484 = t_FindFirstChild_62(v483.dropmodel, "IsCapping");
         local v485 = v484;
         local v486 = t_FindFirstChild_62(v483.dropmodel, "CapPoint");
         local v487 = v486;
         if (v484 and v486) then
            v485.Value = p81;
            v487.Value = p82;
         end
      end
   end);
   local f_dropflag = f_dropflag;
   local f_resetflag = f_resetflag;
   v17:add("dropflag", function(p83, p84, p85, p86, p87)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_dropflag
            2 => f_resetflag
   
      --]]
      f_dropflag(p83, p85, p86, p87);
      f_resetflag(p83, p84);
   end);
   local f_cleanflags = f_cleanflags;
   local f_clearmap;
   f_clearmap = function()
      --[[
         Name: clearmap
         Upvalues: 
            1 => f_cleanflags
   
      --]]
      print("Clearing map");
      workspace.Ignore.GunDrop:ClearAllChildren();
      f_cleanflags();
   end;
   local u122 = v388;
   local u123 = v391;
   local u124 = v17;
   local f_attachflag = f_attachflag;
   local f_dropflag = f_dropflag;
   v17:add("getrounddata", function(p88)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u122
            2 => u123
            3 => u124
            4 => f_attachflag
            5 => f_dropflag
   
      --]]
      print("received game round data");
      local v488 = game.ReplicatedStorage.ServerSettings;
      local t_Value_63 = v488.GameMode.Value;
      if ((v488.AllowSpawn.Value and (t_Value_63 == "Capture the Flag")) and p88.ctf) then
         local g_next_64 = next;
         local v489 = u122;
         local v490 = nil;
         while true do
            local v491, v492 = g_next_64(v489, v490);
            local v493 = v491;
            local v494 = v492;
            if (v491) then
               v490 = v493;
               local v495 = p88.ctf[v494.Name];
               local v496 = v495;
               if (v495 and u123[v494.Name]) then
                  if (v496.droptime) then
                     v496.droptime = u124.fromservertick(v496.droptime);
                  end
                  if (v496.revealtime) then
                     v496.revealtime = u124.fromservertick(v496.revealtime);
                  end
                  u123[v494.Name].basecf = v496.basecf;
                  if (v496.carrier and (not v496.dropped)) then
                     u123[v494.Name].carrier = v496.carrier;
                     u123[v494.Name].revealtime = v496.revealtime;
                     f_attachflag(v496.carrier);
                  else
                     if (v496.dropped) then
                        u123[v494.Name].dropped = true;
                        f_dropflag(v494, v496.dropcf, v496.droptime, false);
                     else
                        u123[v494.Name].dropped = false;
                        f_dropflag(v494, v496.basecf, v496.droptime, true);
                     end
                  end
               end
            else
               break;
            end
         end
      end
   end);
   v19.Reset:connect(f_clearmap);
   local f_gethealthstate = f_gethealthstate;
   local f_gethealth;
   f_gethealth = function(p89)
      --[[
         Name: gethealth
         Upvalues: 
            1 => f_gethealthstate
   
      --]]
      local v497 = f_gethealthstate(p89);
      local v498 = v497;
      if (not v497) then
         return 0, 100;
      end
      local t_health0_65 = v498.health0;
      local t_healtick0_66 = v498.healtick0;
      local t_healrate_67 = v498.healrate;
      local t_maxhealth_68 = v498.maxhealth;
      if (not v498.alive) then
         return 0, t_maxhealth_68;
      end
      local v499 = tick() - t_healtick0_66;
      local v500 = v499;
      if (v499 < 0) then
         return t_health0_65, t_maxhealth_68;
      end
      local v501 = false;
      local v502 = t_health0_65 + ((v500 * v500) * t_healrate_67);
      local v503 = v502;
      local v504;
      if (v502 < t_maxhealth_68) then
         v504 = v503;
         if (not v504) then
            v501 = true;
         end
      else
         v501 = true;
      end
      if (v501) then
         v504 = t_maxhealth_68;
      end
      return v504, t_maxhealth_68;
   end;
   local v505 = v301.SightFront;
   local v506 = v301.SightRear;
   local v507 = v506.ReticleImage;
   local t_SightFront_69 = v505;
   local t_SightRear_70 = v506;
   local f_updatescope;
   f_updatescope = function(p90, p91, p92, p93)
      --[[
         Name: updatescope
         Upvalues: 
            1 => t_SightFront_69
            2 => t_SightRear_70
   
      --]]
      t_SightFront_69.Position = p90;
      t_SightRear_70.Position = p91;
      t_SightFront_69.Size = p92;
      t_SightRear_70.Size = p93;
   end;
   v7.updatescope = f_updatescope;
   local t_SightFront_71 = v505;
   local t_ReticleImage_72 = v507;
   local u125 = v270;
   local f_setscopesettings;
   f_setscopesettings = function(p94, p95)
      --[[
         Name: setscopesettings
         Upvalues: 
            1 => t_SightFront_71
            2 => t_ReticleImage_72
            3 => u125
   
      --]]
      local v508 = t_SightFront_71;
      local v509 = p95.scopelenscolor;
      if (not v509) then
         v509 = Color3.new(0, 0, 0);
      end
      local v510 = false;
      v508.BackgroundColor3 = v509;
      t_SightFront_71.BackgroundTransparency = p95.scopelenstrans or 1;
      local v511 = p95.scopeimagesize or 1;
      t_ReticleImage_72.Image = p95.scopeid;
      local v512 = t_ReticleImage_72;
      local v513;
      if (p95.sightcolor) then
         v513 = Color3.new(p95.sightcolor.r / 255, p95.sightcolor.g / 255, p95.sightcolor.b / 255);
         if (not v513) then
            v510 = true;
         end
      else
         v510 = true;
      end
      if (v510) then
         v513 = p95.scopecolor;
         if (not v513) then
            v513 = Color3.new(1, 1, 1);
         end
      end
      v512.ImageColor3 = v513;
      t_ReticleImage_72.Size = u125(v511, 0, v511, 0);
      t_ReticleImage_72.Position = u125((1 - v511) / 2, 0, (1 - v511) / 2, 0);
   end;
   v7.setscopesettings = f_setscopesettings;
   local u126 = tick();
   local u127 = v13;
   local u128 = v313;
   local u129 = v11;
   local u130 = v17;
   local f_gundrop;
   f_gundrop = function(p96, p97, p98)
      --[[
         Name: gundrop
         Upvalues: 
            1 => f_gunrequire
            2 => u127
            3 => u128
            4 => u129
            5 => u126
            6 => u130
   
      --]]
      if (p97) then
         local v514 = f_gunrequire(p98);
         local v515 = v514;
         if (v514) then
            local v516 = u127.currentgun;
            local t_currentgun_73 = v516;
            if (v516) then
               local v517 = u128;
               local t_controllertype_74 = u129.controllertype;
               local v518;
               if (t_controllertype_74 == "controller") then
                  v518 = "Hold Y";
               else
                  v518 = "Hold V";
               end
               local v519 = false;
               v517.Text = v518 .. (" to pick up [" .. ((v515.displayname or p98) .. "]"));
               local v520 = v515.type;
               local t_type_75 = t_currentgun_73.type;
               if (v520 == t_type_75) then
                  v519 = true;
               else
                  local v521 = v515.ammotype;
                  local t_ammotype_77 = t_currentgun_73.ammotype;
                  if (v521 == t_ammotype_77) then
                     v519 = true;
                  end
               end
               if (v519) then
                  local v522 = tick();
                  if (u126 < v522) then
                     local v523, v524 = t_currentgun_73:dropguninfo();
                     local v525 = v524;
                     if (v524) then
                        local t_sparerounds_76 = t_currentgun_73.sparerounds;
                        if (v525 < t_sparerounds_76) then
                           u126 = v522 + 1;
                           u130:send("getammo", p97, t_currentgun_73.gunnumber);
                           return;
                        end
                     end
                  end
               end
            else
               return;
            end
         end
      else
         u128.Text = "";
      end
   end;
   v7.gundrop = f_gundrop;
   local u131 = v313;
   local f_getuse;
   f_getuse = function(p99)
      --[[
         Name: getuse
         Upvalues: 
            1 => u131
   
      --]]
      return u131.Text ~= "";
   end;
   v7.getuse = f_getuse;
   local u132 = v295;
   local f_enablegamegui;
   f_enablegamegui = function(p100, p101)
      --[[
         Name: enablegamegui
         Upvalues: 
            1 => u132
   
      --]]
      u132.Visible = p101;
   end;
   v7.enablegamegui = f_enablegamegui;
   local u133 = v336;
   local f_togglehudobj;
   f_togglehudobj = function(p102, p103, p104)
      --[[
         Name: togglehudobj
         Upvalues: 
            1 => u133
   
      --]]
      local v526 = u133[p103];
      local v527 = v526;
      if (not v526) then
         warn("hud object not found");
         return;
      end
      local v528 = p104;
      p104 = v528;
      v527.gui.Visible = v528;
      v527.enabled = v528;
   end;
   v7.togglehudobj = f_togglehudobj;
   local f_gethealthstate = f_gethealthstate;
   local f_isplayeralive;
   f_isplayeralive = function(p105, p106)
      --[[
         Name: isplayeralive
         Upvalues: 
            1 => f_gethealthstate
   
      --]]
      if (p106) then
         local v529 = f_gethealthstate(p106);
         local v530 = v529;
         if (v529) then
            return v530.alive;
         end
      end
   end;
   v7.isplayeralive = f_isplayeralive;
   local u134 = v334;
   local f_timesinceplayercombat;
   f_timesinceplayercombat = function(p107, p108)
      --[[
         Name: timesinceplayercombat
         Upvalues: 
            1 => u134
   
      --]]
      return tick() - (u134[p108] or 0);
   end;
   v7.timesinceplayercombat = f_timesinceplayercombat;
   local u135 = v7;
   local u136 = v10;
   local f_getplayerpos;
   f_getplayerpos = function(p109, p110)
      --[[
         Name: getplayerpos
         Upvalues: 
            1 => u135
            2 => u136
   
      --]]
      if (u135:isplayeralive(p110)) then
         return u136.getupdater(p110).getpos();
      end
   end;
   v7.getplayerpos = f_getplayerpos;
   local f_gethealth = f_gethealth;
   local f_getplayerhealth;
   f_getplayerhealth = function(p111, p112)
      --[[
         Name: getplayerhealth
         Upvalues: 
            1 => f_gethealth
   
      --]]
      return f_gethealth(p112);
   end;
   v7.getplayerhealth = f_getplayerhealth;
   local u137 = "Cross";
   local u138 = v7;
   local u139 = v299;
   local f_setcrosssettings;
   f_setcrosssettings = function(p113, p114, p115, p116, p117, p118, p119)
      --[[
         Name: setcrosssettings
         Upvalues: 
            1 => u138
            2 => u57
            3 => u59
            4 => u137
            5 => u139
   
      --]]
      u138.crossspring.t = p115;
      u138.crossspring.s = p116;
      u138.crossspring.d = p117;
      u57 = p118;
      u59 = p119;
      if (p114 == "SHOTGUN") then
         u137 = "Shot";
         local v531 = 1;
         local v532 = v531;
         if (not (v532 >= 4)) then
            while true do
               local g_next_79 = next;
               local v533, v534 = u139[v531]:GetChildren();
               local v535 = v533;
               local v536 = v534;
               while true do
                  local v537, v538 = g_next_79(v535, v536);
                  local v539 = v537;
                  local v540 = v538;
                  if (v537) then
                     v536 = v539;
                     local v541 = v540.Name;
                     local v542 = u137;
                     if (v541 == v542) then
                        v540.Visible = true;
                     end
                  else
                     break;
                  end
               end
               local v543 = v531 + 1;
               v531 = v543;
               if (v543 > 4) then
                  return;
               end
            end
         end
      else
         u137 = "Cross";
         local v544 = 1;
         local v545 = v544;
         if (not (v545 >= 4)) then
            while true do
               local g_next_78 = next;
               local v546, v547 = u139[v544]:GetChildren();
               local v548 = v546;
               local v549 = v547;
               while true do
                  local v550, v551 = g_next_78(v548, v549);
                  local v552 = v550;
                  local v553 = v551;
                  if (v550) then
                     v549 = v552;
                     v553.Visible = false;
                  else
                     break;
                  end
               end
               local v554 = v544 + 1;
               v544 = v554;
               if (v554 > 4) then
                  break;
               end
            end
         end
      end
   end;
   v7.setcrosssettings = f_setcrosssettings;
   local f_updatesightmark;
   f_updatesightmark = function(p120, p121, p122)
      --[[
         Name: updatesightmark
         Upvalues: 
            1 => u57
            2 => u59
   
      --]]
      u57 = p121;
      u59 = p122;
   end;
   v7.updatesightmark = f_updatesightmark;
   local f_updatescopemark;
   f_updatescopemark = function(p123, p124)
      --[[
         Name: updatescopemark
         Upvalues: 
            1 => u58
   
      --]]
      u58 = p124;
   end;
   v7.updatescopemark = f_updatescopemark;
   local u140 = v5;
   local u141 = v336;
   local u142 = v7;
   local u143 = v298;
   local u144 = v299;
   local u145 = v270;
   local t_getscale_80 = v267;
   local u146 = v29;
   local u147 = v303;
   local f_updatecross;
   f_updatecross = function()
      --[[
         Name: updatecross
         Upvalues: 
            1 => u140
            2 => u141
            3 => u142
            4 => u143
            5 => u137
            6 => u144
            7 => u145
            8 => t_getscale_80
            9 => u59
            10 => u57
            11 => u146
            12 => u147
   
      --]]
      if (not ((u140.speed and u140.sprint) and u141.crossframe.enabled)) then
         return;
      end
      local v555 = (((u142.crossspring.p * 2) * u142.crossscale.p) * ((((u140.speed / 14) * 0.2) * 2) + 0.8)) * ((u140.sprint / 2) + 1);
      u143.Visible = false;
      local v556 = u137;
      if (v556 == "Cross") then
         local v557 = 1;
         local v558 = v557;
         if (not (v558 >= 4)) then
            while true do
               u144[v557].BackgroundTransparency = 1 - (v555 / 20);
               local v559 = v557 + 1;
               v557 = v559;
               if (v559 > 4) then
                  break;
               end
            end
         end
      else
         local v560 = 1;
         local v561 = v560;
         if (not (v561 >= 4)) then
            while true do
               u144[v560].BackgroundTransparency = 1;
               local g_next_82 = next;
               local v562, v563 = u144[v560]:GetChildren();
               local v564 = v562;
               local v565 = v563;
               while true do
                  local v566, v567 = g_next_82(v564, v565);
                  local v568 = v566;
                  local v569 = v567;
                  if (v566) then
                     v565 = v568;
                     local v570 = v569.Name;
                     local v571 = u137;
                     if (v570 == v571) then
                        v569.BackgroundTransparency = 1 - ((v555 / 20) * (v555 / 20));
                     end
                  else
                     break;
                  end
               end
               local v572 = v560 + 1;
               v560 = v572;
               if (v572 > 4) then
                  break;
               end
            end
         end
      end
      u144[1].Position = u145(0, v555, 0, 0);
      u144[2].Position = u145(0, (-v555) - 7, 0, 0);
      u144[3].Position = u145(0, 0, 0, v555);
      u144[4].Position = u145(0, 0, 0, (-v555) - 7);
      local v573 = t_getscale_80();
      if (not u59) then
         local t_t_81 = u142.crossspring.t;
         if (((t_t_81 == 0) and u57) and u57.Parent) then
            local v574 = u146.currentcamera:WorldToViewportPoint(u57.Position);
            u147.Position = u145(0, (v574.x / v573) - 125, 0, (v574.y / v573) - 125);
            return;
         end
      end
      u147.Position = u145(0.5, -125, 0.5, -125);
   end;
   local u148 = v332;
   local f_getplayervisible;
   f_getplayervisible = function(p125, p126)
      --[[
         Name: getplayervisible
         Upvalues: 
            1 => u148
   
      --]]
      local v575 = u148[p126];
      local v576 = v575;
      if (v575) then
         return v576.Visible;
      end
   end;
   v7.getplayervisible = f_getplayervisible;
   local v577 = {};
   local t_LocalPlayer_83 = v285;
   local u149 = v577;
   local u150 = v276;
   local t_PlayerTag_84 = v286;
   local t_WaitForChild_85 = v268;
   local u151 = v305;
   local u152 = v332;
   local u153 = v37;
   local u154 = v7;
   local u155 = v10;
   local u156 = v27;
   local u157 = v29;
   local u158 = v22;
   local u159 = v274;
   local t_Dot_86 = v278;
   local u160 = v270;
   local f_gethealth = f_gethealth;
   local u161 = v279;
   local u162 = v12;
   local u163 = v335;
   local f_addnametag;
   f_addnametag = function(p127)
      --[[
         Name: addnametag
         Upvalues: 
            1 => t_LocalPlayer_83
            2 => u149
            3 => u150
            4 => t_PlayerTag_84
            5 => t_WaitForChild_85
            6 => u151
            7 => u152
            8 => u153
            9 => u154
            10 => u155
            11 => u156
            12 => u157
            13 => u158
            14 => u159
            15 => t_Dot_86
            16 => u160
            17 => f_gethealth
            18 => u161
            19 => u162
            20 => u163
   
      --]]
      local v578 = t_LocalPlayer_83;
      if (p127 == v578) then
         return;
      end
      local v579 = {};
      u149[p127] = v579;
      local u164 = nil;
      local u165 = nil;
      local u166 = p127;
      local f_playerchanged;
      f_playerchanged = function(p128)
         --[[
            Name: playerchanged
            Upvalues: 
               1 => u164
               2 => u166
               3 => t_LocalPlayer_83
               4 => u165
               5 => u150
   
         --]]
         if (((p128 == "TeamColor") and u164) and u164.Parent) then
            local v580 = u166.TeamColor;
            local t_TeamColor_87 = t_LocalPlayer_83.TeamColor;
            if (v580 == t_TeamColor_87) then
               u164.Visible = true;
               u165.Visible = false;
               u164.TextColor3 = u150(0, 1, 0.9176470588235294);
               u164.Dot.BackgroundTransparency = 1;
               return;
            end
            u164.Visible = false;
            u165.Visible = false;
            u164.TextColor3 = u150(1, 0.0392156862745098, 0.07843137254901961);
            u164.Dot.BackgroundTransparency = 1;
         end
      end;
      local u167 = p127;
      local f_playerchanged = f_playerchanged;
      local f_newtag;
      f_newtag = function()
         --[[
            Name: newtag
            Upvalues: 
               1 => u164
               2 => t_PlayerTag_84
               3 => u167
               4 => u165
               5 => t_WaitForChild_85
               6 => u151
               7 => f_playerchanged
               8 => u152
   
         --]]
         u164 = t_PlayerTag_84:Clone();
         u164.Text = u167.Name;
         u164.Visible = false;
         u165 = t_WaitForChild_85(u164, "Health");
         u164.Dot.BackgroundTransparency = 1;
         u164.TextTransparency = 1;
         u164.TextStrokeTransparency = 1;
         u164.Parent = u151;
         f_playerchanged("TeamColor");
         u152[u167] = u164;
      end;
      f_newtag();
      local u168 = p127;
      local f_update;
      f_update = function()
         --[[
            Name: update
            Upvalues: 
               1 => u153
               2 => u164
               3 => u165
               4 => u154
               5 => u168
               6 => u155
               7 => u156
               8 => u157
               9 => u158
               10 => u159
               11 => t_Dot_86
               12 => u160
               13 => t_LocalPlayer_83
               14 => u150
               15 => f_gethealth
               16 => u161
               17 => u162
   
         --]]
         local v581 = u153.getscale();
         if (not (u164.Parent and u165.Parent)) then
            return;
         end
         if (u154:isplayeralive(u168)) then
            local v582, v583 = u155.getupdater(u168).getpos();
            local v584 = v582;
            local v585 = v583;
            if (v582 and v583) then
               if (u156.sphere(v584, 4)) then
                  local v586 = u157.cframe;
                  local v587 = u157.currentcamera:WorldToScreenPoint(v585 + u158.vtws(v586, u159(0, 0.625, 0))) / v581;
                  local v588 = (v584 - v586.Position).magnitude;
                  local v589 = t_Dot_86(u157.lookvector, (v584 - v586.Position).unit);
                  local v590 = (((1 / (v589 * v589)) - 1) ^ 0.5) * v588;
                  u164.Position = u160(0, v587.x - 75, 0, v587.y);
                  local v591 = u168.TeamColor;
                  local t_TeamColor_88 = t_LocalPlayer_83.TeamColor;
                  if (v591 == t_TeamColor_88) then
                     u164.Visible = true;
                     u165.Visible = true;
                     u164.TextColor3 = u150(0, 1, 0.9176470588235294);
                     u164.Dot.BackgroundColor3 = u150(0, 1, 0.9176470588235294);
                     local v592, v593 = f_gethealth(u168);
                     local v594 = v592;
                     local v595 = v593;
                     if (v590 < 4) then
                        u164.TextTransparency = 0.125;
                        u165.BackgroundTransparency = 0.75;
                        u165.Percent.BackgroundTransparency = 0.25;
                        u165.Percent.Size = u160(v594 / v595, 0, 1, 0);
                        u164.Dot.BackgroundTransparency = 1;
                        return;
                     end
                     if (not (v590 < 8)) then
                        u164.Dot.BackgroundTransparency = 0.125;
                        u164.TextTransparency = 1;
                        u165.BackgroundTransparency = 1;
                        u165.Percent.BackgroundTransparency = 1;
                        return;
                     end
                     u164.TextTransparency = 0.125 + ((0.875 * (v590 - 4)) / 4);
                     u165.BackgroundTransparency = 0.75 + ((0.25 * (v590 - 4)) / 4);
                     u165.Percent.BackgroundTransparency = 0.25 + ((0.75 * (v590 - 4)) / 4);
                     u165.Percent.Size = u160(v594 / v595, 0, 1, 0);
                     u164.Dot.BackgroundTransparency = 1;
                     return;
                  end
                  u164.Dot.BackgroundTransparency = 1;
                  u165.Visible = false;
                  u164.TextColor3 = u150(1, 0.0392156862745098, 0.07843137254901961);
                  u164.Dot.BackgroundColor3 = u150(1, 0.0392156862745098, 0.07843137254901961);
                  if (u154:isspotted(u168) and u154:isinsight(u168)) then
                     u164.Visible = true;
                     if (v590 < 4) then
                        u164.TextTransparency = 0;
                        return;
                     end
                     u164.TextTransparency = 1;
                     u164.Dot.BackgroundTransparency = 0;
                     return;
                  end
                  if ((not u154:isspotted(u168)) and (v590 < 4)) then
                     local v596 = u157.cframe.p;
                     local v597 = not workspace:FindPartOnRayWithWhitelist(u161(v596, v584 - v596), u162.raycastwhitelist);
                     u164.Visible = v597;
                     if (v597) then
                        if (v590 < 2) then
                           u164.Visible = true;
                           u164.TextTransparency = 0.125;
                           return;
                        end
                        if (not (v590 < 4)) then
                           u164.Visible = false;
                           return;
                        end
                        u164.Visible = true;
                        u164.TextTransparency = (0.4375 * v590) - 0.75;
                        return;
                     end
                  else
                     u164.Visible = false;
                     u165.Visible = false;
                     return;
                  end
               else
                  u164.Visible = false;
                  u165.Visible = false;
                  return;
               end
            end
         else
            u164.Visible = false;
            u165.Visible = false;
         end
      end;
      v579[(#v579) + 1] = p127.Changed:connect(f_playerchanged);
      v579[(#v579) + 1] = t_LocalPlayer_83.Changed:connect(f_playerchanged);
      u163[p127] = f_update;
   end;
   v7.addnametag = f_addnametag;
   local u169 = v335;
   local u170 = v332;
   v7.removenametag = function(p129)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u169
            2 => u170
   
      --]]
      u169[p129] = nil;
      if (u170[p129]) then
         u170[p129]:Destroy();
      end
      u170[p129] = nil;
   end;
   game:GetService("Players").PlayerAdded:connect(f_addnametag);
   local v598 = game:GetService("Players").PlayerRemoving;
   local u171 = v333;
   local u172 = v334;
   local u173 = v7;
   local u174 = v577;
   v598:connect(function(p130)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u171
            2 => u172
            3 => u173
            4 => u174
   
      --]]
      u171[p130] = nil;
      u172[p130] = nil;
      u173.removenametag(p130);
      local v599 = u174[p130];
      local v600 = v599;
      if (v599) then
         local v601 = 1;
         local v602 = #v600;
         local v603 = v602;
         local v604 = v601;
         if (not (v602 <= v604)) then
            while true do
               v600[v601]:Disconnect();
               v600[v601] = nil;
               local v605 = v601 + 1;
               v601 = v605;
               local v606 = v603;
               if (v606 < v605) then
                  break;
               end
            end
         end
         u174[p130] = nil;
      end
   end);
   local g_next_89 = next;
   local v607, v608 = game:GetService("Players"):GetPlayers();
   local v609 = v607;
   local v610 = v608;
   while true do
      local v611, v612 = g_next_89(v609, v610);
      local v613 = v611;
      local v614 = v612;
      if (v611) then
         v610 = v613;
         f_addnametag(v614);
      else
         break;
      end
   end
   local u175 = v335;
   local u176 = v332;
   local f_updateplayernames;
   f_updateplayernames = function()
      --[[
         Name: updateplayernames
         Upvalues: 
            1 => u175
            2 => u176
   
      --]]
      local g_next_90 = next;
      local v615 = u175;
      local v616 = nil;
      while true do
         local v617, v618 = g_next_90(v615, v616);
         local v619 = v617;
         if (v617) then
            v616 = v619;
            if (v619 and v619.Parent) then
               u175[v619]();
            else
               u175[v619] = nil;
               if (u176[v619]) then
                  u176[v619]:Destroy();
               end
               u176[v619] = nil;
            end
         else
            break;
         end
      end
   end;
   local u177 = v307;
   local u178 = v331;
   local u179 = v271;
   local f_capping;
   f_capping = function(p131, p132, p133, p134)
      --[[
         Name: capping
         Upvalues: 
            1 => u177
            2 => u178
            3 => u179
   
      --]]
      local v620;
      if (p134 == "ctf") then
         v620 = 100;
      else
         v620 = 50;
      end
      if (not p132) then
         u177.Visible = false;
         return;
      end
      u177.Visible = true;
      local t_Note_91 = u177.Note;
      local v621;
      if (p134 == "ctf") then
         v621 = "Recovering...";
      else
         v621 = "Capturing...";
      end
      t_Note_91.Text = v621;
      u178.Size = u179(p133 / v620, 0, 1, 0);
   end;
   v7.capping = f_capping;
   local u180 = v317;
   local f_setsteadybar;
   f_setsteadybar = function(p135, p136)
      --[[
         Name: setsteadybar
         Upvalues: 
            1 => u180
   
      --]]
      u180.Size = p136;
   end;
   v7.setsteadybar = f_setsteadybar;
   local u181 = v317;
   local f_getsteadysize;
   f_getsteadysize = function(p137)
      --[[
         Name: getsteadysize
         Upvalues: 
            1 => u181
   
      --]]
      return u181.Size.X.Scale;
   end;
   v7.getsteadysize = f_getsteadysize;
   local u182 = v7;
   local f_setcrossscale;
   f_setcrossscale = function(p138, p139)
      --[[
         Name: setcrossscale
         Upvalues: 
            1 => u182
   
      --]]
      u182.crossscale.t = p139;
   end;
   v7.setcrossscale = f_setcrossscale;
   local u183 = v7;
   local f_setcrosssize;
   f_setcrosssize = function(p140, p141)
      --[[
         Name: setcrosssize
         Upvalues: 
            1 => u183
   
      --]]
      u183.crossspring.t = p141;
   end;
   v7.setcrosssize = f_setcrosssize;
   local u184 = nil;
   local u185 = nil;
   local u186 = nil;
   local u187 = v302;
   local u188 = v312;
   local u189 = v11;
   local u190 = v41;
   local f_setscope;
   f_setscope = function(p142, p143, p144)
      --[[
         Name: setscope
         Upvalues: 
            1 => u187
            2 => u188
            3 => u189
            4 => u190
            5 => u186
            6 => u184
   
      --]]
      u187.Visible = p143;
      local v622 = u188;
      local v623 = p143;
      if (v623) then
         v623 = not p144;
      end
      v622.Visible = v623;
      local v624 = u188;
      local t_controllertype_92 = u189.controllertype;
      local v625;
      if (t_controllertype_92 == "controller") then
         v625 = "Tap LS to Toggle Steady Scope";
      else
         v625 = "Hold Shift to Steady Scope";
      end
      v624.Text = v625;
      if (p143) then
         u190.play("useScope", 0.25);
         u186 = true;
         delay(0.5, u184);
      end
      if (not p143) then
         u186 = false;
      end
   end;
   v7.setscope = f_setscope;
   local u191 = v7;
   local u192 = v41;
   u184 = function()
      --[[
         Name: heartIn
         Upvalues: 
            1 => u186
            2 => u191
            3 => u192
            4 => u185
   
      --]]
      if (u186) then
         local v626 = u191:getsteadysize() / 5;
         u192.play("heartBeatIn", 0.05 + v626);
         delay(0.3 + v626, u185);
      end
   end;
   local u193 = v7;
   local u194 = v41;
   u185 = function()
      --[[
         Name: heartOut
         Upvalues: 
            1 => u186
            2 => u193
            3 => u194
            4 => u184
   
      --]]
      if (u186) then
         local v627 = u193:getsteadysize() / 4;
         u194.play("heartBeatOut", 0.05 + v627);
         delay(0.5 + v627, u184);
      end
   end;
   local u195 = v322;
   local u196 = v324;
   local u197 = v323;
   local u198 = v13;
   local f_updateammo;
   f_updateammo = function(p145, p146, p147)
      --[[
         Name: updateammo
         Upvalues: 
            1 => u195
            2 => u196
            3 => u197
            4 => u198
   
      --]]
      if (p146 == "KNIFE") then
         u195.Text = "- - -";
         u196.Text = "- - -";
         return;
      end
      if (p146 ~= "GRENADE") then
         u195.Text = p147;
         u196.Text = p146;
         return;
      end
      u195.Text = "- - -";
      u196.Text = "- - -";
      u197.Text = u198.gammo .. "x";
   end;
   v7.updateammo = f_updateammo;
   local u199 = v326;
   local f_updatefiremode;
   f_updatefiremode = function(p148, p149)
      --[[
         Name: updatefiremode
         Upvalues: 
            1 => u199
   
      --]]
      local v628 = u199;
      local v629;
      if (p149 == "KNIFE") then
         v629 = "- - -";
      else
         if (p149 == true) then
            v629 = "AUTO";
         else
            if (p149 == 1) then
               v629 = "SEMI";
            else
               v629 = "BURST";
            end
         end
      end
      v628.Text = v629;
   end;
   v7.updatefiremode = f_updatefiremode;
   local u200 = v7;
   local u201 = v304;
   local f_firehitmarker;
   f_firehitmarker = function(p150, p151)
      --[[
         Name: firehitmarker
         Upvalues: 
            1 => u200
            2 => u201
   
      --]]
      u200.hitspring.p = -3;
      if (p151) then
         u201.ImageColor3 = Color3.new(1, 0, 0);
         return;
      end
      u201.ImageColor3 = Color3.new(1, 1, 1);
   end;
   v7.firehitmarker = f_firehitmarker;
   local v630 = {};
   v630.lightred = v277(0.7843137254901961, 0.196078431372549, 0.196078431372549);
   v630.lightblue = v277(0, 0.7843137254901961, 1);
   v630.green = v277(0, 1, 0.2);
   v630.red = v277(1, 0, 0);
   local v631 = v336.radar;
   local v632 = math.pi / 180;
   local v633 = t_WaitForChild_20(t_ReplicatedStorage_24, "MiniMapModels");
   local v634 = t_WaitForChild_20(t_ReplicatedStorage_24.ServerSettings, "MapName");
   local v635 = t_WaitForChild_20(v633, "Temp");
   local u202 = 0;
   local u203 = false;
   local u204 = 0;
   local v636 = t_WaitForChild_20(v296, "MiniMapFrame");
   local u205 = nil;
   local u206 = nil;
   local u207 = nil;
   local v637 = workspace:FindFirstChild("Map");
   local u208 = nil;
   local u209 = nil;
   local u210 = nil;
   local v638 = {};
   v638.players = {};
   v638.objectives = {};
   v638.rings = {};
   local v639 = t_WaitForChild_20(v296, "Radar");
   local v640 = t_WaitForChild_20(v639, "Folder");
   local v641 = v294.AbsoluteSize.X;
   local v642 = v294.AbsoluteSize.Y;
   local v643 = v639.AbsoluteSize.X;
   local v644 = v639.AbsoluteSize.Y;
   local v645 = {};
   local v646 = {};
   local v647 = {};
   local v648 = t_WaitForChild_20(v639, "Me");
   v648.Size = v271(0, 16, 0, 16);
   v648.Position = v271(0.5, -8, 0.5, -8);
   local v649 = {};
   v649.players = v648;
   v649.objectives = t_WaitForChild_20(v639, "Objective");
   local f_reset_minimap;
   f_reset_minimap = function(p152)
      --[[
         Name: reset_minimap
      --]]
   end;
   v7.reset_minimap = f_reset_minimap;
   local u211 = v637;
   local u212 = t_FindFirstChild_21;
   local u213 = v636;
   local u214 = v282;
   local u215 = v634;
   local u216 = v633;
   local u217 = v635;
   local f_set_minimap;
   f_set_minimap = function(p153)
      --[[
         Name: set_minimap
         Upvalues: 
            1 => u211
            2 => u208
            3 => u209
            4 => u212
            5 => u207
            6 => u213
            7 => u214
            8 => u205
            9 => u215
            10 => u216
            11 => u206
            12 => u217
   
      --]]
      if (u211) then
         u208 = u211.PrimaryPart;
         u209 = u212(u211, "AGMP");
         local v650 = u212(u213, "Camera");
         if (not v650) then
            v650 = u214("Camera");
         end
         u207 = v650;
         u207.FieldOfView = 45;
         u213.CurrentCamera = u207;
         u207.Parent = u213;
         if (u205) then
            local v651 = u205.Name;
            local t_Value_93 = u215.Value;
            if (v651 == t_Value_93) then
            end
         end
         if (u205) then
            u205:Destroy();
         end
         local v652 = u212(u216, u215.Value);
         local v653 = v652;
         if (v652) then
            u205 = v653:Clone();
            u205.Parent = u213;
            u206 = u205.PrimaryPart;
            return;
         end
         u205 = u217:Clone();
         u205.Parent = u213;
         u206 = u205.PrimaryPart;
         return;
      end
      print("Did not find map");
   end;
   v7.set_minimap = f_set_minimap;
   local f_gen_minimap_pos;
   f_gen_minimap_pos = function(p154)
      --[[
         Name: gen_minimap_pos
         Upvalues: 
            1 => u208
            2 => u206
            3 => u207
            4 => u210
   
      --]]
      local v654, v655 = u207:WorldToViewportPoint(((u208.CFrame:inverse() * p154).p * 0.2) + u206.Position);
      local v656 = v655;
      local v657 = v654.X;
      local v658 = v654.Y;
      local v659 = v657 - 0.5;
      local v660 = 0.5 - v658;
      local v661 = (math.atan(v659 / v660) * 180) / math.pi;
      if (v660 < 0) then
         v661 = v661 - 180;
      end
      if (v657 > 1) then
         v657 = 1;
      end
      if (v657 < 0) then
         v657 = 0;
      end
      if (v658 > 1) then
         v658 = 1;
      end
      if (v658 < 0) then
         v658 = 0;
      end
      return v657, v658, math.abs(p154.p.Y - u210.CFrame.p.Y), v656, v661;
   end;
   local u218 = v638;
   local u219 = v648;
   local u220 = v271;
   local u221 = v630;
   local u222 = v640;
   local f_get_ring;
   f_get_ring = function(p155)
      --[[
         Name: get_ring
         Upvalues: 
            1 => u218
            2 => u219
            3 => u220
            4 => u221
            5 => u222
   
      --]]
      if (not u218.rings[p155]) then
         local v662 = u219:Clone();
         v662.Size = u220(0, 0, 0, 0);
         v662.ImageColor3 = u221.lightred;
         v662.Image = "rbxassetid://2925606552";
         v662.Height.Visible = false;
         v662.Parent = u222;
         u218.rings[p155] = v662;
      end
      return u218.rings[p155];
   end;
   local u223 = v638;
   local u224 = v649;
   local u225 = v271;
   local u226 = v640;
   local f_get_arrow;
   f_get_arrow = function(p156, p157)
      --[[
         Name: get_arrow
         Upvalues: 
            1 => u223
            2 => u224
            3 => u225
            4 => u226
   
      --]]
      if (not u223[p157][p156]) then
         local v663 = u224[p157]:Clone();
         v663.Size = u225(0, 14, 0, 14);
         v663.Parent = u226;
         u223[p157][p156] = v663;
      end
      return u223[p157][p156];
   end;
   local f_gen_minimap_pos = f_gen_minimap_pos;
   local f_get_ring = f_get_ring;
   local u227 = t_LocalPlayer_23;
   local u228 = v630;
   local u229 = v271;
   local f_update_minimap_ring;
   f_update_minimap_ring = function(p158, p159)
      --[[
         Name: update_minimap_ring
         Upvalues: 
            1 => f_gen_minimap_pos
            2 => f_get_ring
            3 => u227
            4 => u228
            5 => u229
   
      --]]
      local v664 = false;
      local v665, v666, v667, v668 = f_gen_minimap_pos(p159.refcf);
      local v669 = v665;
      local v670 = v666;
      local v671 = f_get_ring(p158);
      local v672 = p159.size0 or 4;
      local v673 = p159.size1 or 30;
      local v674 = (tick() - p159.shottime) / p159.lifetime;
      local v675 = v674;
      local v676 = v672 + ((v673 - v672) * v674);
      local v677 = p159.teamcolor;
      local t_TeamColor_94 = u227.TeamColor;
      local v678;
      if (v677 == t_TeamColor_94) then
         v678 = u228.lightblue;
         if (not v678) then
            v664 = true;
         end
      else
         v664 = true;
      end
      if (v664) then
         v678 = u228.lightred;
      end
      v671.ImageColor3 = v678;
      v671.ImageTransparency = v675;
      v671.Size = u229(0, v676, 0, v676);
      v671.Position = u229(v669, (-v676) / 2, v670, (-v676) / 2);
      v671.Visible = true;
   end;
   local f_gen_minimap_pos = f_gen_minimap_pos;
   local f_get_arrow = f_get_arrow;
   local u230 = t_LocalPlayer_23;
   local u231 = v630;
   local u232 = v271;
   local f_update_minimap_object;
   f_update_minimap_object = function(p160, p161, p162, p163, p164, p165, p166, p167)
      --[[
         Name: update_minimap_object
         Upvalues: 
            1 => f_gen_minimap_pos
            2 => f_get_arrow
            3 => u230
            4 => u231
            5 => u204
            6 => u203
            7 => u208
            8 => u232
   
      --]]
      local v679, v680, v681, v682, v683 = f_gen_minimap_pos(p163);
      local v684 = v679;
      local v685 = v680;
      local v686 = v682;
      local v687 = v683;
      local v688 = 14;
      local v689 = 0.002 * (v681 ^ 2.5);
      local v690 = f_get_arrow(p165, p166);
      local v691 = nil;
      if (p166 == "players") then
         local v692;
         if (p160) then
            v692 = "rbxassetid://2911984939";
         else
            v692 = "rbxassetid://3116912054";
         end
         local v693 = false;
         v690.Image = v692;
         local t_TeamColor_95 = u230.TeamColor;
         local v694;
         if (p162 == t_TeamColor_95) then
            v694 = u231.lightblue;
            if (not v694) then
               v693 = true;
            end
         else
            v693 = true;
         end
         if (v693) then
            v694 = u231.red;
         end
         v691 = v694;
         if (p161) then
            v691 = u231.green;
         end
         v690.ImageColor3 = v691;
         v690.Height.ImageColor3 = v690.ImageColor3;
         v690.Height.Visible = (not p161) and p160;
         v690.Height.ImageTransparency = p164 or 0;
         local v695, v696, v697 = p163:ToOrientation();
         local v698 = (v696 * 180) / math.pi;
         local v699 = u204;
         if (u203) then
            v699 = u208.Orientation.Y;
         end
         if (v686) then
            v690.Rotation = v699 - v698;
            v690.ImageTransparency = p164 or v689;
         else
            v690.Rotation = v687;
            v688 = 12;
            local v700;
            if (p160) then
               v700 = "rbxassetid://2910531391";
            else
               v700 = "rbxassetid://3116912054";
            end
            v690.Image = v700;
            v690.ImageTransparency = p164 or 0;
         end
         v690.Size = u232(0, v688, 0, v688);
      else
         if (p166 == "objectives") then
            v691 = p162.Color;
            v690.Label.Text = p167;
            v690.Label.TextColor3 = v691;
            v690.Label.Visible = true;
         end
      end
      v690.ImageColor3 = v691;
      v690.Position = u232(v684, (-v688) / 2, v685, (-v688) / 2);
      v690.Visible = true;
   end;
   local u233 = t_LocalPlayer_23;
   local u234 = v645;
   local u235 = v273;
   local u236 = v646;
   local u237 = v7;
   local f_fireradar;
   f_fireradar = function(p168, p169, p170, p171, p172)
      --[[
         Name: fireradar
         Upvalues: 
            1 => u233
            2 => u234
            3 => u235
            4 => u236
            5 => u237
   
      --]]
      local v701 = p169.TeamColor ~= u233.TeamColor;
      local v702 = v701;
      local v703 = u234[p169];
      if ((not v703) and v701) then
         local v704 = {};
         v704.refcf = u235();
         v704.shottime = 0;
         v704.lifetime = 0;
         v703 = v704;
         u234[p169] = v703;
      end
      local v705 = u236[p169];
      if (not v705) then
         local v706 = {};
         v706.refcf = u235();
         v706.shottime = 0;
         v706.lifetime = 0;
         v706.teamcolor = p169.TeamColor;
         v705 = v706;
         u236[p169] = v705;
      end
      if (u237:isplayeralive(p169)) then
         v705.refcf = p172;
         v705.teamcolor = p169.TeamColor;
         v705.lifetime = p171.pinglife or 0.5;
         v705.size0 = p171.size0;
         v705.size1 = p171.size1;
         local v707 = tick();
         if ((v705.shottime + v705.lifetime) < v707) then
            v705.shottime = tick();
         end
         if ((not p170) and v702) then
            v703.refcf = p172;
            v703.lifetime = 5;
            v703.shottime = tick();
         end
      end
   end;
   v7.fireradar = f_fireradar;
   local f_set_rel_height;
   f_set_rel_height = function(p173)
      --[[
         Name: set_rel_height
         Upvalues: 
            1 => u202
   
      --]]
      local v708 = u202;
      local v709;
      if (v708 == 0) then
         v709 = 1;
      else
         v709 = 0;
      end
      u202 = v709;
   end;
   v7.set_rel_height = f_set_rel_height;
   local f_set_minimap_style;
   f_set_minimap_style = function(p174)
      --[[
         Name: set_minimap_style
         Upvalues: 
            1 => u203
   
      --]]
      u203 = not u203;
   end;
   v7.set_minimap_style = f_set_minimap_style;
   local u238 = v30;
   local u239 = v5;
   local u240 = v648;
   local u241 = v630;
   local u242 = v275;
   local u243 = v273;
   local u244 = v632;
   local u245 = v10;
   local u246 = v647;
   local u247 = t_LocalPlayer_23;
   local u248 = v7;
   local f_update_minimap_object = f_update_minimap_object;
   local u249 = v645;
   local u250 = v646;
   local f_update_minimap_ring = f_update_minimap_ring;
   local u251 = t_FindFirstChild_21;
   local f_updateminimap;
   f_updateminimap = function()
      --[[
         Name: updateminimap
         Upvalues: 
            1 => u208
            2 => u206
            3 => u210
            4 => u238
            5 => u239
            6 => u240
            7 => u241
            8 => u242
            9 => u202
            10 => u204
            11 => u203
            12 => u207
            13 => u243
            14 => u244
            15 => u245
            16 => u246
            17 => u247
            18 => u248
            19 => f_update_minimap_object
            20 => u249
            21 => u250
            22 => f_update_minimap_ring
            23 => u209
            24 => u251
   
      --]]
      if (not u208) then
         return print("No map found");
      end
      if (not u206) then
         return print("No minimap found");
      end
      local v710 = u238:isspectating();
      if (not v710) then
         v710 = u238.currentcamera;
      end
      u210 = v710;
      if (u239.alive) then
         u240.Visible = true;
         u240.ImageColor3 = u241.lightblue;
      else
         u240.Visible = u238:isspectating();
         u240.ImageColor3 = u241.red;
      end
      u240.Height.ImageColor3 = u240.ImageColor3;
      local v711 = ((u208.CFrame:inverse() * u210.CFrame).p * 0.2) * u242(1, u202, 1);
      local v712, v713, v714 = u238.cframe:ToOrientation();
      u204 = (v713 * 180) / math.pi;
      local v715 = u208.Orientation.Y - u204;
      local v716 = v711 + u206.Position;
      if (u203) then
         u207.CFrame = u243(v716 + u242(0, 50, 0)) * CFrame.Angles(-90 * u244, 0, 0);
         u240.Rotation = v715;
      else
         u207.CFrame = (u243(v716 + u242(0, 50, 0)) * CFrame.Angles(0, (-v715) * u244, 0)) * CFrame.Angles(-90 * u244, 0, 0);
         u240.Rotation = 0;
      end
      local v717 = 0;
      local v718 = game:GetService("Players"):GetPlayers();
      local v719 = v718;
      local v720 = 1;
      local v721 = #v718;
      local v722 = v721;
      local v723 = v720;
      if (not (v721 <= v723)) then
         while true do
            local v724 = nil;
            local v725 = v719[v720];
            local v726 = v725;
            local v727 = u245.getbodyparts(v725);
            local v728 = u246[v725];
            local v729 = u247 == v725;
            local v730 = u248:isplayeralive(v725);
            if (not v730) then
               v730 = v729;
               if (v730) then
                  v730 = u239.alive;
               end
            end
            if (v727) then
               v724 = v727.rootpart;
            else
               if (v729) then
                  v724 = u239.rootpart;
               end
            end
            if (not v728) then
               local v731 = {};
               v731.lastcf = u243();
               v731.alivetick = 0;
               v728 = v731;
               u246[v726] = v728;
            end
            if (v724 and v730) then
               v728.lastcf = v724.CFrame;
               v728.alivetick = tick();
            end
            local v732 = nil;
            local v733 = not v729;
            if (v733) then
               v733 = v726.TeamColor == u247.TeamColor;
            end
            if (v730) then
               if (((not v733) and u248:isspotted(v726)) and u248:isinsight(v726)) then
                  v732 = 0;
                  v733 = true;
               end
            else
               local v734 = false;
               local v735 = (tick() - v728.alivetick) / 5;
               local v736;
               if (v735 > 0.1) then
                  v736 = v735 ^ 0.5;
                  if (not v736) then
                     v734 = true;
                  end
               else
                  v734 = true;
               end
               if (v734) then
                  v736 = 0;
               end
               v732 = math.min(v736, 1);
               v733 = true;
            end
            local v737 = v728.lastcf;
            local t_lastcf_101 = v737;
            if (v737 and v733) then
               v717 = v717 + 1;
               f_update_minimap_object(v730, v729, v726.TeamColor, t_lastcf_101, v732, v717, "players");
            end
            local v738 = v720 + 1;
            v720 = v738;
            local v739 = v722;
            if (v739 < v738) then
               break;
            end
         end
      end
      local g_next_96 = next;
      local v740 = u249;
      local v741 = nil;
      while true do
         local v742, v743 = g_next_96(v740, v741);
         local v744 = v742;
         local v745 = v743;
         if (v742) then
            v741 = v744;
            local v746 = (v745.shottime + v745.lifetime) - tick();
            if (v744.Parent) then
               if (v746 > 0) then
                  local v747 = false;
                  local v748 = u248:isplayeralive(v744);
                  local v749 = (tick() - v745.shottime) / v745.lifetime;
                  local v750;
                  if (v749 > 0.1) then
                     v750 = v749 ^ 0.5;
                     if (not v750) then
                        v747 = true;
                     end
                  else
                     v747 = true;
                  end
                  if (v747) then
                     v750 = 0;
                  end
                  if (v748) then
                     v717 = v717 + 1;
                     f_update_minimap_object(v748, false, v744.TeamColor, v745.refcf, v750, v717, "players");
                  end
               end
            else
               u249[v744] = nil;
            end
         else
            break;
         end
      end
      local v751 = 0;
      local g_next_97 = next;
      local v752 = u250;
      local v753 = nil;
      while true do
         local v754, v755 = g_next_97(v752, v753);
         local v756 = v754;
         local v757 = v755;
         if (v754) then
            v753 = v756;
            local v758 = (v757.shottime + v757.lifetime) - tick();
            if (v756.Parent) then
               if (v758 > 0) then
                  v751 = v751 + 1;
                  f_update_minimap_ring(v751, v757);
               end
            else
               u250[v756] = nil;
            end
         else
            break;
         end
      end
      local v759 = 0;
      if (u209) then
         local v760 = u209:GetChildren();
         local v761 = v760;
         local v762 = 1;
         local v763 = #v760;
         local v764 = v763;
         local v765 = v762;
         if (not (v763 <= v765)) then
            while true do
               local v766 = v761[v762];
               local v767 = v766;
               local v768 = u251(v766, "Base");
               local v769 = u251(v766, "TeamColor");
               local v770 = u251(v766, "Letter");
               local v771 = nil;
               local t_Name_98 = v766.Name;
               if (t_Name_98 == "Flag") then
                  local v772 = false;
                  local v773;
                  if (v770) then
                     v773 = v770.Value;
                     if (not v773) then
                        v772 = true;
                     end
                  else
                     v772 = true;
                  end
                  if (v772) then
                     v773 = "";
                  end
                  v771 = v773;
               else
                  local t_Name_99 = v767.Name;
                  if (t_Name_99 == "FlagBase") then
                     v771 = "F";
                  else
                     local t_Name_100 = v767.Name;
                     if (t_Name_100 == "HPFlag") then
                        v771 = "P";
                     end
                  end
               end
               if (v768) then
                  v759 = v759 + 1;
                  f_update_minimap_object(nil, nil, v769.Value, v768.CFrame, nil, v759, "objectives", v771);
               end
               local v774 = v762 + 1;
               v762 = v774;
               local v775 = v764;
               if (v775 < v774) then
                  break;
               end
            end
         end
      end
   end;
   local u252 = v640;
   local u253 = v647;
   local f_reset_radar_pool;
   f_reset_radar_pool = function()
      --[[
         Name: reset_radar_pool
         Upvalues: 
            1 => u252
            2 => u253
   
      --]]
      local v776 = u252:GetChildren();
      local v777 = v776;
      local v778 = 1;
      local v779 = #v776;
      local v780 = v779;
      local v781 = v778;
      if (not (v779 <= v781)) then
         while true do
            v777[v778].Visible = false;
            local v782 = v778 + 1;
            v778 = v782;
            local v783 = v780;
            if (v783 < v782) then
               break;
            end
         end
      end
      local g_next_102 = next;
      local v784 = u253;
      local v785 = nil;
      while true do
         local v786, v787 = g_next_102(v784, v785);
         local v788 = v786;
         if (v786) then
            v785 = v788;
            if (not v788.Parent) then
               u253[v788] = nil;
            end
         else
            break;
         end
      end
   end;
   local u254 = v11;
   local t_radar_103 = v631;
   local f_reset_radar_pool = f_reset_radar_pool;
   local f_updateminimap = f_updateminimap;
   local f_radarstep;
   f_radarstep = function()
      --[[
         Name: radarstep
         Upvalues: 
            1 => u254
            2 => t_radar_103
            3 => f_reset_radar_pool
            4 => f_updateminimap
   
      --]]
      if (not u254:isdeployed()) then
         return;
      end
      if (t_radar_103.enabled) then
         f_reset_radar_pool();
         f_updateminimap();
      end
   end;
   v7.radarstep = f_radarstep;
   local u255 = v5;
   local u256 = v325;
   local u257 = v308;
   local u258 = v328;
   local u259 = v330;
   local u260 = v329;
   local f_updatehealth;
   f_updatehealth = function()
      --[[
         Name: updatehealth
         Upvalues: 
            1 => u255
            2 => u256
            3 => u60
            4 => u257
            5 => u258
            6 => u259
            7 => u260
   
      --]]
      local v789 = u255.gethealth();
      local v790 = v789;
      local t_maxhealth_104 = u255.maxhealth;
      u256.Text = v789 + ((-v789) % 1);
      local v791 = u60;
      if (v789 < v791) then
         local v792 = u60 - v790;
         u257.ImageTransparency = u257.ImageTransparency - ((v792 / u60) * 0.7);
         u257.BackgroundTransparency = (u257.BackgroundTransparency - ((v792 / u60) * 0.5)) + 0.3;
      else
         if ((u60 < v790) or (v790 == t_maxhealth_104)) then
            u257.ImageTransparency = u257.ImageTransparency + 0.001;
            u257.BackgroundTransparency = u257.BackgroundTransparency + 0.001;
         else
            if (v790 <= 0) then
               u257.ImageTransparency = 1;
               u257.BackgroundTransparency = 1;
            end
         end
      end
      u60 = v790;
      local v793 = t_maxhealth_104 / 4;
      if (v790 <= v793) then
         u258.BackgroundColor3 = u259[4];
         u260.BackgroundColor3 = u259[3];
      else
         u258.BackgroundColor3 = u259[1];
         u260.BackgroundColor3 = u259[2];
      end
      u260.Size = UDim2.new(math.floor(v790) / t_maxhealth_104, 0, 1, 0);
   end;
   local v794 = {};
   local v795 = {};
   local v796 = {};
   local u261 = v5;
   local u262 = v30;
   local u263 = t_LocalPlayer_23;
   local u264 = v7;
   local u265 = v10;
   local u266 = t_Dot_22;
   local u267 = v280;
   local u268 = v12;
   local u269 = v795;
   local u270 = v18;
   local f_spot;
   f_spot = function(p175)
      --[[
         Name: spot
         Upvalues: 
            1 => u261
            2 => u262
            3 => u263
            4 => u264
            5 => u265
            6 => u266
            7 => u267
            8 => u268
            9 => u269
            10 => u270
   
      --]]
      local v797 = {};
      if (u261.alive) then
         local v798 = u262.cframe;
         local t_cframe_105 = v798;
         local t_unit_106 = v798.lookVector.unit;
         local v799 = game:GetService("Players"):GetPlayers();
         local v800 = v799;
         local t_TeamColor_107 = u263.TeamColor;
         local v801 = 1;
         local v802 = #v799;
         local v803 = v802;
         local v804 = v801;
         if (not (v802 <= v804)) then
            while true do
               local v805 = v800[v801];
               local v806 = v805;
               if (u264:isplayeralive(v805) and (not (v806.TeamColor == t_TeamColor_107))) then
                  local v807 = u265.getbodyparts(v806);
                  local v808 = v807;
                  if (v807 and v807.head) then
                     local v809 = v808.head.Position - u262.cframe.p;
                     local v810 = u266(t_unit_106, v809.unit);
                     if ((v810 > 0.96592582628) and (not workspace:FindPartOnRayWithWhitelist(u267(t_cframe_105.p, v809), u268.raycastwhitelist))) then
                        u269[v806] = true;
                        v797[(#v797) + 1] = v806;
                     end
                  end
               end
               local v811 = v801 + 1;
               v801 = v811;
               local v812 = v803;
               if (v812 < v811) then
                  break;
               end
            end
         end
         local v813 = #v797;
         if (v813 > 0) then
            u270:send("spotplayers", v797);
            return true;
         end
      end
   end;
   v7.spot = f_spot;
   local u271 = v796;
   v18:add("brokensight", function(p176, p177)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u271
   
      --]]
      if (p176) then
         u271[p176] = p177;
      end
   end);
   local u272 = v794;
   v18:add("spotplayer", function(p178)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u272
   
      --]]
      if (p178) then
         u272[p178] = true;
      end
   end);
   local u273 = v794;
   v18:add("unspotplayer", function(p179)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u273
   
      --]]
      if (p179) then
         u273[p179] = nil;
      end
   end);
   local u274 = v794;
   local f_isspotted;
   f_isspotted = function(p180, p181)
      --[[
         Name: isspotted
         Upvalues: 
            1 => u274
   
      --]]
      return u274[p181];
   end;
   v7.isspotted = f_isspotted;
   local u275 = v796;
   local u276 = v795;
   local u277 = t_LocalPlayer_23;
   local f_isinsight;
   f_isinsight = function(p182, p183)
      --[[
         Name: isinsight
         Upvalues: 
            1 => u275
            2 => u276
            3 => u277
   
      --]]
      local v814 = not u275[p183];
      if (not v814) then
         v814 = u276[u277];
      end
      return v814;
   end;
   v7.isinsight = f_isinsight;
   local u278 = v794;
   local u279 = v7;
   local u280 = v5;
   local u281 = t_LocalPlayer_23;
   local u282 = v10;
   local u283 = v28;
   local u284 = v30;
   local u285 = v280;
   local u286 = v12;
   local u287 = v795;
   local u288 = v18;
   local u289 = v315;
   local u290 = t_FindFirstChild_21;
   local f_spotstep;
   f_spotstep = function()
      --[[
         Name: spotstep
         Upvalues: 
            1 => u278
            2 => u279
            3 => u280
            4 => u281
            5 => u282
            6 => u283
            7 => u284
            8 => u285
            9 => u286
            10 => u287
            11 => u288
            12 => u289
            13 => u290
   
      --]]
      local g_next_108 = next;
      local v815 = u278;
      local v816 = nil;
      while true do
         local v817, v818 = g_next_108(v815, v816);
         local v819 = v817;
         if (v817) then
            local v820 = false;
            v816 = v819;
            local v821 = false;
            if (u279.spectating) then
               v820 = true;
            else
               if (u280.alive) then
                  local v822 = v819.TeamColor;
                  local t_TeamColor_109 = u281.TeamColor;
                  if (v822 ~= t_TeamColor_109) then
                     v820 = true;
                  end
               end
            end
            if (v820) then
               local v823 = u282.getbodyparts(v819);
               if (((v823 and v823.torso) and u283.sphere(v823.torso.Position, 4)) and (not workspace:FindPartOnRayWithWhitelist(u285(u284.cframe.p, v823.head.Position - u284.cframe.p), u286.raycastwhitelist))) then
                  v821 = true;
                  if (not u287[v819]) then
                     u287[v819] = true;
                     u288:send("updatesight", v819, true, tick());
                  end
               end
            end
            if ((not v821) and u287[v819]) then
               u287[v819] = false;
               u288:send("updatesight", v819, false, tick());
            end
         else
            break;
         end
      end
      if (u279:isspotted(u281)) then
         u289.Visible = true;
         if (u279:isinsight(u281)) then
            u289.Text = "Spotted by enemy!";
            u289.TextColor3 = Color3.new(1, 0.125, 0.125);
            return;
         end
         u289.Text = "Hiding from enemy...";
         u289.TextColor3 = Color3.new(0.125, 1, 0.125);
         return;
      end
      local v824 = u290(u289, "Spottimer");
      local v825 = v824;
      if (v824) then
         local t_Value_110 = v825.Timer.Value;
         if (t_Value_110 > 0) then
            u289.Visible = true;
            u289.Text = "On Radar!";
            u289.TextColor3 = Color3.new(1, 0.8, 0);
            return;
         end
      end
      u289.Visible = false;
   end;
   v7.spotstep = f_spotstep;
   local u291 = t_FindFirstChild_21;
   local u292 = v315;
   local u293 = v282;
   local f_goingloud;
   f_goingloud = function(p184)
      --[[
         Name: goingloud
         Upvalues: 
            1 => u291
            2 => u292
            3 => u293
   
      --]]
      local v826 = u291(u292, "Spottimer");
      local v827 = v826;
      local v828;
      if (v826) then
         v828 = v827.Timer;
      else
         local v829 = u293("Model");
         v829.Name = "Spottimer";
         v828 = u293("IntValue");
         v828.Name = "Timer";
         v828.Parent = v829;
         v829.Parent = u292;
      end
      local v830;
      if (v828.Value <= 30) then
         v830 = 30;
      else
         local v831 = v828.Value + 30;
         if (v831 > 200) then
            v830 = 200;
         else
            v830 = v828.Value + 30;
         end
      end
      v828.Value = v830;
   end;
   v7.goingloud = f_goingloud;
   local u294 = v296;
   local u295 = t_BloodArc_25;
   local u296 = v30;
   v18:add("shot", function(p185, p186, p187)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u294
            2 => u295
            3 => u296
   
      --]]
      local v832 = u294:GetChildren();
      local v833 = v832;
      local v834 = 1;
      local v835 = #v832;
      local v836 = v835;
      local v837 = v834;
      if (not (v835 <= v837)) then
         while true do
            local t_Name_111 = v833[v834].Name;
            if (t_Name_111 == "BloodArc") then
               local v838 = v833[v834].Player.Value;
               local t_Name_112 = p185.Name;
               if (v838 == t_Name_112) then
                  v833[v834]:Destroy();
               end
            end
            local v839 = v834 + 1;
            v834 = v839;
            local v840 = v836;
            if (v840 < v839) then
               break;
            end
         end
      end
      local v841 = u295:Clone();
      v841.Pos.Value = p186;
      v841.Player.Value = p185.Name;
      v841.Parent = u294;
      u296:hit((((-p187) / 12) + 4.166666666666667) * (u296.cframe.p - p186).unit);
   end);
   local u297 = v334;
   v18:add("updatecombat", function(p188)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u297
   
      --]]
      if (p188) then
         u297[p188] = tick();
      end
   end);
   local u298 = v7;
   local u299 = v35;
   local u300 = v8;
   local u301 = v34;
   local u302 = v296;
   local u303 = t_FindFirstChild_21;
   local u304 = v294;
   local f_reloadhud;
   f_reloadhud = function(p189)
      --[[
         Name: reloadhud
         Upvalues: 
            1 => u298
            2 => u299
            3 => u300
            4 => u301
            5 => u302
            6 => u303
            7 => u304
   
      --]]
      u298:reset_minimap();
      u298:set_minimap();
      u298:setscope(false);
      u299:reload();
      u300:reset();
      u301:reset();
      local v842 = u302:GetChildren();
      local v843 = v842;
      local v844 = 1;
      local v845 = #v842;
      local v846 = v845;
      local v847 = v844;
      if (not (v845 <= v847)) then
         while true do
            local t_Name_113 = v843[v844].Name;
            if (t_Name_113 == "BloodArc") then
               v843[v844]:Destroy();
            end
            local v848 = v844 + 1;
            v844 = v848;
            local v849 = v846;
            if (v849 < v848) then
               break;
            end
         end
      end
      local v850 = u303(u304, "KillBar");
      local v851 = v850;
      if (v850) then
         v851:Destroy();
      end
   end;
   v7.reloadhud = f_reloadhud;
   local f_updateplayernames = f_updateplayernames;
   local f_updatehealth = f_updatehealth;
   local f_beat;
   f_beat = function()
      --[[
         Name: beat
         Upvalues: 
            1 => f_updateplayernames
            2 => f_updatehealth
   
      --]]
      f_updateplayernames();
      f_updatehealth();
   end;
   v7.beat = f_beat;
   local u305 = v304;
   local u306 = v7;
   local u307 = v296;
   local f_updatecross = f_updatecross;
   local u308 = t_FindFirstChild_21;
   local u309 = v315;
   local f_step;
   f_step = function()
      --[[
         Name: step
         Upvalues: 
            1 => u305
            2 => u306
            3 => u307
            4 => f_updatecross
            5 => u61
            6 => u62
            7 => u308
            8 => u309
   
      --]]
      u305.ImageTransparency = u306.hitspring.p;
      if (u307.Visible) then
         local v852 = tick();
         f_updatecross();
         if ((u61 + 0.01666666666666667) < v852) then
            u306.gamemoderenderstep();
            u61 = v852 + 0.01666666666666667;
         end
         if ((u62 + 0.1) < v852) then
            u306.spotstep();
            u306.gamemodestep();
            local v853 = u308(u309, "Spottimer");
            local v854 = v853;
            if (v853) then
               local t_Value_114 = v854.Timer.Value;
               if (t_Value_114 > 0) then
                  v854.Timer.Value = v854.Timer.Value - 1;
               end
            end
            u62 = v852 + 0.1;
         end
      end
      u306.votestep();
   end;
   v7.step = f_step;
   print("Loading notify module");
   local v855 = v38.getscale;
   local v856 = game.WaitForChild;
   local v857 = game.FindFirstChild;
   local v858 = UDim2.new;
   local v859 = Vector3.new;
   local v860 = Color3.new;
   local v861 = Vector3.new().Dot;
   local v862 = Ray.new;
   local v863 = workspace.FindPartOnRayWithIgnoreList;
   local v864 = Instance.new;
   local v865 = game:GetService("Players").LocalPlayer;
   local v866 = game.ReplicatedStorage.Misc;
   local v867 = v865.PlayerGui;
   local u310 = v856(v867, "MainGui");
   local u311 = v856(u310, "GameGui");
   local u312 = v856(u311, "NotifyList");
   local v868 = v866.Main;
   local v869 = v866.Side;
   local v870 = v866.KillBar;
   local v871 = v866.RankBar;
   local v872 = v866.AttachBar;
   local v873 = {};
   v873.kill = {
      "Enemy Killed!"
   };
   v873.collx2 = {
      "Double Collateral!"
   };
   v873.collx3 = {
      "Triple Collateral!"
   };
   v873.collxn = {
      "Multi Collateral!"
   };
   v873.killx2 = {
      "Double Kill!"
   };
   v873.killx3 = {
      "Triple Kill!"
   };
   v873.killx4 = {
      "Quad Kill!"
   };
   v873.killxn = {
      "Multi Kill!"
   };
   v873.backstab = {
      "Backstab!"
   };
   v873.assist = {
      "Assist!"
   };
   v873.suppression = {
      "Suppressed Enemy!"
   };
   v873.assistkill = {
      "Assist Count As Kill!"
   };
   v873.head = {
      "Headshot Bonus!"
   };
   v873.wall = {
      "Wallbang Bonus!"
   };
   v873.spot = {
      "Spot Bonus!"
   };
   v873.long = {
      "Killed from a distance!",
      "Long Shot!"
   };
   v873.squad = {
      "Teammate spawned on you",
      "Squadmate spawned on you"
   };
   v873.flagsteal = {
      "Acquired Enemy Flag!",
      "Stolen Enemy Flag!"
   };
   v873.flagcapture = {
      "Captured Enemy Flag!"
   };
   v873.flagteamcap = {
      "Team Captured Enemy Flag!"
   };
   v873.flagrecover = {
      "Recovered Team Flag!"
   };
   v873.flagdef1 = {
      "Killed Enemy Flag Carrier!"
   };
   v873.flagdef2 = {
      "Protected Flag Carrier!"
   };
   v873.flagdef3 = {
      "Denied Enemy Capture!"
   };
   v873.flagdef4 = {
      "Denied Enemy Pick Up!"
   };
   v873.flagdef5 = {
      "Flag Guard Kill!"
   };
   v873.flagdef6 = {
      "Flag Recover Kill!"
   };
   v873.flagsup1 = {
      "Flag Escort Kill!"
   };
   v873.flagsup2 = {
      "Killed Enemy Flag Escort!"
   };
   v873.flagsup3 = {
      "Assisted by Teammate!"
   };
   v873.flagsup4 = {
      "Protected Flag Carrier Under Fire!",
      "Protected Flag Carrier!"
   };
   v873.flagsup5 = {
      "Saved by Teammate!"
   };
   v873.flagsup6 = {
      "Protected by Teammate!"
   };
   v873.flagoff1 = {
      "Offensive Flag Kill!"
   };
   v873.flagoff2 = {
      "Denied Enemy Flag Recovery!"
   };
   v873.flagoff3 = {
      "Killed Enemy Flag Guard!"
   };
   v873.dogtagself = {
      "Secured Personal Tag!"
   };
   v873.dogtagconfirm = {
      "Kill Confirmed!"
   };
   v873.dogtagteam = {
      "Teammate Confirmed Kill!"
   };
   v873.dogtagdeny = {
      "Denied Enemy Kill!"
   };
   v873.domcap = {
      "Captured a position!"
   };
   v873.domcapping = {
      "Capturing position"
   };
   v873.domdefend = {
      "Defended a position!"
   };
   v873.domassault = {
      "Assaulted a position!"
   };
   v873.domattack = {
      "Attacked a position!"
   };
   v873.dombuzz = {
      "Stopped an enemy capture!"
   };
   v873.kingcap = {
      "Captured the hill!"
   };
   v873.kingholding = {
      "Holding hill"
   };
   v873.kingcapping = {
      "Capturing hill"
   };
   v873.hphold = {
      "Holding point!",
      "Holding position!"
   };
   v873.hpdefend = {
      "Defended position!",
      "Defended point!"
   };
   v873.hpassault = {
      "Assaulted point!",
      "Assaulted position!"
   };
   v873.hpattack = {
      "Attacked position!",
      "Attacked point!"
   };
   v873[" "] = {};
   local u313 = v41;
   local f_typeout;
   f_typeout = function(p190, p191)
      --[[
         Name: typeout
         Upvalues: 
            1 => u313
   
      --]]
      p190.AutoLocalize = false;
      local v874 = p191 or 2;
      local v875 = p190.Text;
      p190.Text = "";
      local g_spawn_115 = spawn;
      local t_Text_116 = v875;
      local u314 = p190;
      local u315 = v874;
      g_spawn_115(function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => t_Text_116
               2 => u314
               3 => u315
               4 => u313
   
         --]]
         local v876 = 1;
         local v877, v878, v879 = utf8.graphemes(t_Text_116);
         local v880 = v877;
         local v881 = v878;
         local v882 = v879;
         while true do
            local v883, v884 = v880(v881, v882);
            local v885 = v883;
            local v886 = v884;
            if (v883) then
               break;
            end
            v882 = v885;
            u314.Text = u314.Text .. t_Text_116:sub(v885, v886);
            if ((v876 * u315) < v885) then
               u313.play("ui_typeout", 0.2);
               v876 = v876 + 1;
               wait(0.01666666666666667);
            end
         end
      end);
   end;
   local u316 = v41;
   local f_queuetypeout;
   f_queuetypeout = function(p192, p193)
      --[[
         Name: queuetypeout
         Upvalues: 
            1 => u316
   
      --]]
      p192.AutoLocalize = false;
      local v887 = p193 or 3;
      local v888 = p192.Text;
      local t_Text_117 = v888;
      p192.Text = "";
      local v889 = 1;
      local v890, v891, v892 = utf8.graphemes(v888);
      local v893 = v890;
      local v894 = v891;
      local v895 = v892;
      while true do
         local v896, v897 = v893(v894, v895);
         local v898 = v896;
         local v899 = v897;
         if (v896) then
            break;
         end
         v895 = v898;
         p192.Text = p192.Text .. t_Text_117:sub(v898, v899);
         if ((v889 * v887) < v898) then
            u316.play("ui_typeout", 0.2);
            v889 = v889 + 1;
            wait(0.01666666666666667);
         end
      end
   end;
   local t_Side_118 = v869;
   local t_WaitForChild_119 = v856;
   local u317 = v41;
   local u318 = v858;
   local f_typeout = f_typeout;
   local f_customaward;
   f_customaward = function(p194, p195)
      --[[
         Name: customaward
         Upvalues: 
            1 => t_Side_118
            2 => t_WaitForChild_119
            3 => u312
            4 => u317
            5 => u318
            6 => f_typeout
   
      --]]
      local v900 = t_Side_118:Clone();
      local v901 = v900;
      local v902 = t_WaitForChild_119(v900, "Primary");
      v900.Parent = u312;
      u317.play("ui_smallaward", 0.2);
      local v903 = u312:GetChildren();
      local v904 = v903;
      local v905 = 1;
      local v906 = #v903;
      local v907 = v906;
      local v908 = v905;
      if (not (v906 <= v908)) then
         while true do
            local v909 = v904[v905];
            local v910 = v909;
            if (v909:IsA("Frame") and v909.Parent) then
               v910:TweenPosition(u318(0, 0, 0, ((#v904) - v905) * 20), "Out", "Sine", 0.05, true);
            end
            local v911 = v905 + 1;
            v905 = v911;
            local v912 = v907;
            if (v912 < v911) then
               break;
            end
         end
      end
      local g_spawn_120 = spawn;
      local u319 = v902;
      local u320 = p195;
      local u321 = v901;
      g_spawn_120(function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u319
               2 => u320
               3 => f_typeout
               4 => u321
   
         --]]
         u319.Text = u320;
         u319.TextTransparency = 0;
         f_typeout(u319, 3);
         wait(5.5);
         local v913 = 1;
         local v914 = v913;
         if (not (v914 >= 10)) then
            while true do
               u319.TextTransparency = v913 / 10;
               u319.TextStrokeTransparency = (v913 / 10) + 0.4;
               wait(0.01666666666666667);
               local v915 = v913 + 1;
               v913 = v915;
               if (v915 > 10) then
                  break;
               end
            end
         end
         wait(0.1);
         u321:Destroy();
      end);
   end;
   v8.customaward = f_customaward;
   local t_AttachBar_121 = v872;
   local u322 = v858;
   local f_customevent;
   f_customevent = function(p196, p197)
      --[[
         Name: customevent
         Upvalues: 
            1 => t_AttachBar_121
            2 => u322
            3 => u310
   
      --]]
      local v916 = t_AttachBar_121:Clone();
      local v917 = v916.Title;
      local v918 = v916.Attach;
      v916.Position = u322(0.5, 0, 0.15, 0);
      v917.Text = p196;
      v918.Text = p197;
      v916.Parent = u310;
      local v919 = tick() + 6;
      local u323 = nil;
      local v920 = game:GetService("RunService").RenderStepped;
      local u324 = v919;
      local t_Attach_122 = v918;
      local t_Title_123 = v917;
      local u325 = v916;
      u323 = v920:connect(function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u324
               2 => t_Attach_122
               3 => t_Title_123
               4 => u323
               5 => u325
   
         --]]
         local v921 = u324 - tick();
         local v922 = v921;
         local v923 = t_Attach_122;
         local v924;
         if (v921 < 5) then
            v924 = 0;
         else
            local v925 = false;
            if (v922 < 5.5) then
               v924 = (v922 - 5) / 0.5;
               if (not v924) then
                  v925 = true;
               end
            else
               v925 = true;
            end
            if (v925) then
               v924 = 1;
            end
         end
         v923.TextTransparency = v924;
         local v926 = t_Title_123;
         local v927;
         if (v922 < 5) then
            v927 = 0;
         else
            local v928 = false;
            if (v922 < 5.5) then
               v927 = (v922 - 5) / 0.5;
               if (not v927) then
                  v928 = true;
               end
            else
               v928 = true;
            end
            if (v928) then
               v927 = 1;
            end
         end
         v926.TextTransparency = v927;
         if (v922 <= 0) then
            u323:disconnect();
            u325:Destroy();
         end
      end);
   end;
   local t_Side_124 = v869;
   local t_WaitForChild_125 = v856;
   local u326 = v41;
   local u327 = v858;
   local u328 = v873;
   local f_typeout = f_typeout;
   local f_smallaward;
   f_smallaward = function(p198, p199)
      --[[
         Name: smallaward
         Upvalues: 
            1 => t_Side_124
            2 => t_WaitForChild_125
            3 => u326
            4 => u312
            5 => u327
            6 => u328
            7 => f_typeout
   
      --]]
      local v929 = p199 or 25;
      local v930 = t_Side_124:Clone();
      local v931 = v930;
      local v932 = t_WaitForChild_125(v930, "Primary");
      local v933 = t_WaitForChild_125(v930, "Point");
      u326.play("ui_smallaward", 0.2);
      v930.Parent = u312;
      local v934 = u312:GetChildren();
      local v935 = v934;
      local v936 = 1;
      local v937 = #v934;
      local v938 = v937;
      local v939 = v936;
      if (not (v937 <= v939)) then
         while true do
            local v940 = v935[v936];
            local v941 = v940;
            if (v940:IsA("Frame") and v940.Parent) then
               v941:TweenPosition(u327(0, 0, 0, ((#v935) - v936) * 20), "Out", "Sine", 0.05, true);
            end
            local v942 = v936 + 1;
            v936 = v942;
            local v943 = v938;
            if (v943 < v942) then
               break;
            end
         end
      end
      v933.Text = "[+" .. (v929 .. "]");
      local v944 = u328[p198];
      local v945 = v944;
      local v946 = #v944;
      if (v946 > 1) then
         v932.Text = v945[math.random(1, #v945)];
      else
         v932.Text = v945[1];
      end
      if (p198 == "head") then
         u326.play("headshotkill", 0.45);
      end
      v933.TextTransparency = 0;
      v932.TextTransparency = 0;
      f_typeout(v933, 3);
      f_typeout(v932, 3);
      wait(5.5);
      local v947 = 1;
      local v948 = v947;
      if (not (v948 >= 10)) then
         while true do
            v933.TextTransparency = v947 / 10;
            v932.TextTransparency = v947 / 10;
            v933.TextStrokeTransparency = (v947 / 10) + 0.4;
            v932.TextStrokeTransparency = (v947 / 10) + 0.4;
            wait(0.01666666666666667);
            local v949 = v947 + 1;
            v947 = v949;
            if (v949 > 10) then
               break;
            end
         end
      end
      wait(0.1);
      v931:Destroy();
   end;
   local t_Main_126 = v868;
   local t_WaitForChild_127 = v856;
   local t_getscale_128 = v855;
   local u329 = v858;
   local u330 = v873;
   local u331 = v41;
   local f_typeout = f_typeout;
   local f_queuetypeout = f_queuetypeout;
   local f_bigaward;
   f_bigaward = function(p200, p201, p202, p203)
      --[[
         Name: bigaward
         Upvalues: 
            1 => t_Main_126
            2 => t_WaitForChild_127
            3 => t_getscale_128
            4 => u312
            5 => u329
            6 => u330
            7 => u331
            8 => f_typeout
            9 => f_queuetypeout
   
      --]]
      local v950 = t_Main_126:Clone();
      local v951 = v950;
      local v952 = t_WaitForChild_127(v950, "Overlay");
      local v953 = t_WaitForChild_127(v950, "Primary");
      local v954 = t_WaitForChild_127(v950, "Point");
      local v955 = t_WaitForChild_127(v950, "Enemy");
      local v956 = t_getscale_128();
      v950.Parent = u312;
      local v957 = u312:GetChildren();
      local v958 = v957;
      local v959 = 1;
      local v960 = #v957;
      local v961 = v960;
      local v962 = v959;
      if (not (v960 <= v962)) then
         while true do
            local v963 = v958[v959];
            local v964 = v963;
            if (v963:IsA("Frame") and v963.Parent) then
               v964:TweenPosition(u329(0, 0, 0, ((#v958) - v959) * 20), "Out", "Sine", 0.05, true);
            end
            local v965 = v959 + 1;
            v959 = v965;
            local v966 = v961;
            if (v966 < v965) then
               break;
            end
         end
      end
      v954.Text = "[+" .. (p203 .. "]");
      local v967 = u330[p200];
      local v968 = v967;
      local v969 = #v967;
      if (v969 > 1) then
         v953.Text = v968[math.random(1, #v968)];
      else
         v953.Text = v968[1];
      end
      v955.Text = p201.Name or "";
      v955.TextColor3 = p201.TeamColor.Color;
      u331.play("ui_begin", 0.4);
      if (p200 == "kill") then
         u331.play("killshot", 0.2);
      end
      v954.TextTransparency = 0;
      v954.TextStrokeTransparency = 0;
      v953.TextTransparency = 0;
      v953.TextStrokeTransparency = 0;
      v955.TextTransparency = 1;
      v955.TextStrokeTransparency = 1;
      v952.ImageTransparency = 0.2;
      v952:TweenSizeAndPosition(u329(0, 200, 0, 80), u329(0.5, -150, 0.7, -40), "Out", "Linear", 0, true);
      f_typeout(v954);
      f_typeout(v953);
      local g_spawn_129 = spawn;
      local u332 = v952;
      g_spawn_129(function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u332
               2 => u329
   
         --]]
         wait(0.05);
         local v970 = 1;
         local v971 = v970;
         if (not (v971 >= 10)) then
            while true do
               u332.ImageTransparency = v970 / 10;
               wait(0.1);
               local v972 = v970 + 1;
               v970 = v972;
               if (v972 > 10) then
                  break;
               end
            end
         end
         u332.Size = u329(0, 200, 0, 80);
         u332.Position = u329(0.55, -100, 0.3, -40);
      end);
      v952:TweenSizeAndPosition(u329(0, 300, 0, 30), u329(0.5, -150, 0.7, -15), "Out", "Linear", 0.05, true);
      wait(0.05);
      v952:TweenSizeAndPosition(u329(0, 500, 0, 8), u329(0.5, -150, 0.7, -4), "Out", "Linear", 0.05, true);
      wait(1.5);
      local v973 = 1;
      local v974 = v973;
      if (not (v974 >= 2)) then
         while true do
            v953.TextTransparency = 1;
            v953.TextStrokeTransparency = 1;
            u331.play("ui_blink", 0.4);
            wait(0.1);
            v953.TextTransparency = 0;
            v953.TextStrokeTransparency = 0;
            wait(0.1);
            local v975 = v973 + 1;
            v973 = v975;
            if (v975 > 2) then
               break;
            end
         end
      end
      v953.TextTransparency = 1;
      v953.TextStrokeTransparency = 1;
      wait(0.2);
      v955.TextTransparency = 0;
      v955.TextStrokeTransparency = 0;
      f_queuetypeout(v955, 4);
      v953.TextTransparency = 0;
      v953.TextStrokeTransparency = 0;
      v953.Position = u329(0.5, (v955.TextBounds.x / v956) + 10, 0.7, -10);
      if (p200 == "kill") then
         v953.Text = "[" .. (p202 .. "]");
      else
         v953.Text = p202;
      end
      f_queuetypeout(v953, 4);
      wait(3);
      local v976 = 1;
      local v977 = v976;
      if (not (v977 >= 10)) then
         while true do
            v954.TextTransparency = v976 / 10;
            v953.TextTransparency = v976 / 10;
            v955.TextTransparency = v976 / 10;
            v954.TextStrokeTransparency = (v976 / 10) + 0.4;
            v953.TextStrokeTransparency = (v976 / 10) + 0.4;
            v955.TextStrokeTransparency = (v976 / 10) + 0.4;
            wait(0.01666666666666667);
            local v978 = v976 + 1;
            v976 = v978;
            if (v978 > 10) then
               break;
            end
         end
      end
      wait(0.1);
      v951:Destroy();
   end;
   local t_AttachBar_130 = v872;
   local u333 = v858;
   local f_unlockedgun;
   f_unlockedgun = function(p204)
      --[[
         Name: unlockedgun
         Upvalues: 
            1 => t_AttachBar_130
            2 => u333
            3 => u310
   
      --]]
      local v979 = t_AttachBar_130:Clone();
      local v980 = v979.Title;
      local v981 = v979.Attach;
      v979.Position = u333(0.5, 0, 0.15, 0);
      v979.Parent = u310;
      v980.Text = "Unlocked New Weapon!";
      v981.Text = p204;
      local v982 = tick();
      local u334 = nil;
      local v983 = game:GetService("RunService").RenderStepped;
      local u335 = v982;
      local t_Attach_131 = v981;
      local t_Title_132 = v980;
      local u336 = v979;
      u334 = v983:connect(function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u335
               2 => t_Attach_131
               3 => t_Title_132
               4 => u334
               5 => u336
   
         --]]
         local v984 = tick() - u335;
         local v985 = v984;
         local v986 = t_Attach_131;
         local v987;
         if (v984 < 2) then
            v987 = 0;
         else
            local v988 = false;
            if (v985 < 2.5) then
               v987 = (v985 - 2) / 0.5;
               if (not v987) then
                  v988 = true;
               end
            else
               v988 = true;
            end
            if (v988) then
               v987 = 1;
            end
         end
         v986.TextTransparency = v987;
         local v989 = t_Title_132;
         local v990;
         if (v985 < 2) then
            v990 = 0;
         else
            local v991 = false;
            if (v985 < 2.5) then
               v990 = (v985 - 2) / 0.5;
               if (not v990) then
                  v991 = true;
               end
            else
               v991 = true;
            end
            if (v991) then
               v990 = 1;
            end
         end
         v989.TextTransparency = v990;
         if (v985 > 3) then
            u334:disconnect();
            u336:Destroy();
         end
      end);
   end;
   local t_AttachBar_133 = v872;
   local u337 = v858;
   local f_unlockedattach;
   f_unlockedattach = function(p205, p206, p207)
      --[[
         Name: unlockedattach
         Upvalues: 
            1 => t_AttachBar_133
            2 => u337
            3 => u310
   
      --]]
      local v992 = 1;
      local v993 = #p206;
      local v994 = v993;
      local v995 = v992;
      if (not (v993 <= v995)) then
         while true do
            local v996 = p206[v992];
            local v997 = p207[v992];
            local v998 = t_AttachBar_133:Clone();
            local v999 = v998.Money;
            local v1000 = v998.Title;
            local v1001 = v998.Attach;
            v998.Position = u337(0.5, 0, 0.15, 0);
            v998.Parent = u310;
            v1000.Text = "Unlocked " .. (p205 .. " Attachment");
            v1001.Text = v996;
            v999.Text = "[+200]";
            local v1002 = tick();
            local u338 = nil;
            local v1003 = game:GetService("RunService").RenderStepped;
            local u339 = v1002;
            local t_Attach_134 = v1001;
            local t_Title_135 = v1000;
            local t_Money_136 = v999;
            local u340 = v998;
            u338 = v1003:connect(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u339
                     2 => t_Attach_134
                     3 => t_Title_135
                     4 => t_Money_136
                     5 => u338
                     6 => u340
   
               --]]
               local v1004 = tick() - u339;
               local v1005 = v1004;
               local v1006 = t_Attach_134;
               local v1007;
               if (v1004 < 2) then
                  v1007 = 0;
               else
                  local v1008 = false;
                  if (v1005 < 2.5) then
                     v1007 = (v1005 - 2) / 0.5;
                     if (not v1007) then
                        v1008 = true;
                     end
                  else
                     v1008 = true;
                  end
                  if (v1008) then
                     v1007 = 1;
                  end
               end
               v1006.TextTransparency = v1007;
               local v1009 = t_Title_135;
               local v1010;
               if (v1005 < 2) then
                  v1010 = 0;
               else
                  local v1011 = false;
                  if (v1005 < 2.5) then
                     v1010 = (v1005 - 2) / 0.5;
                     if (not v1010) then
                        v1011 = true;
                     end
                  else
                     v1011 = true;
                  end
                  if (v1011) then
                     v1010 = 1;
                  end
               end
               v1009.TextTransparency = v1010;
               local v1012 = t_Money_136;
               local v1013;
               if (v1005 < 0.5) then
                  v1013 = 1;
               else
                  if (v1005 < 2.5) then
                     v1013 = 0;
                  else
                     local v1014 = false;
                     if (v1005 < 3) then
                        v1013 = (v1005 - 2.5) / 0.5;
                        if (not v1013) then
                           v1014 = true;
                        end
                     else
                        v1014 = true;
                     end
                     if (v1014) then
                        v1013 = 1;
                     end
                  end
               end
               v1012.TextTransparency = v1013;
               if (v1005 > 3) then
                  u338:disconnect();
                  u340:Destroy();
               end
            end);
            wait(3);
            local v1015 = v992 + 1;
            v992 = v1015;
            local v1016 = v994;
            if (v1016 < v1015) then
               break;
            end
         end
      end
   end;
   local t_RankBar_137 = v871;
   local f_unlockedgun = f_unlockedgun;
   local f_rankup;
   f_rankup = function(p208, p209, p210)
      --[[
         Name: rankup
         Upvalues: 
            1 => t_RankBar_137
            2 => u310
            3 => f_unlockedgun
   
      --]]
      local v1017 = t_RankBar_137:Clone();
      local v1018 = v1017;
      local t_Money_138 = v1017.Money;
      local t_Title_139 = v1017.Title;
      local t_Rank_140 = v1017.Rank;
      local v1019 = 0;
      local v1020 = u310:GetChildren();
      local v1021 = v1020;
      local v1022 = 1;
      local v1023 = #v1020;
      local v1024 = v1023;
      local v1025 = v1022;
      if (not (v1023 <= v1025)) then
         while true do
            local v1026 = false;
            local t_Name_141 = v1021[v1022].Name;
            if (t_Name_141 == "RankBar") then
               v1026 = true;
            else
               local t_Name_142 = v1021[v1022].Name;
               if (t_Name_142 == "AttachBar") then
                  v1026 = true;
               end
            end
            if (v1026) then
               v1019 = v1019 + 1;
            end
            local v1027 = v1022 + 1;
            v1022 = v1027;
            local v1028 = v1024;
            if (v1028 < v1027) then
               break;
            end
         end
      end
      v1018.Parent = u310;
      t_Rank_140.Text = p209;
      t_Money_138.Text = "+" .. ((((5 * (p209 - p208)) * ((81 + p209) + p208)) / 2) .. " CR");
      local v1029 = tick();
      local u341 = nil;
      local v1030 = game:GetService("RunService").RenderStepped;
      local u342 = v1029;
      local u343 = t_Rank_140;
      local u344 = t_Title_139;
      local u345 = t_Money_138;
      local u346 = v1018;
      local u347 = p210;
      u341 = v1030:connect(function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u342
               2 => u343
               3 => u344
               4 => u345
               5 => u341
               6 => u346
               7 => u347
               8 => f_unlockedgun
   
         --]]
         local v1031 = tick() - u342;
         local v1032 = v1031;
         local v1033 = u343;
         local v1034;
         if (v1031 < 3) then
            v1034 = 0;
         else
            local v1035 = false;
            if (v1032 < 3.5) then
               v1034 = (v1032 - 3) / 0.5;
               if (not v1034) then
                  v1035 = true;
               end
            else
               v1035 = true;
            end
            if (v1035) then
               v1034 = 1;
            end
         end
         v1033.TextTransparency = v1034;
         local v1036 = u344;
         local v1037;
         if (v1032 < 3) then
            v1037 = 0;
         else
            local v1038 = false;
            if (v1032 < 3.5) then
               v1037 = (v1032 - 3) / 0.5;
               if (not v1037) then
                  v1038 = true;
               end
            else
               v1038 = true;
            end
            if (v1038) then
               v1037 = 1;
            end
         end
         v1036.TextTransparency = v1037;
         local v1039 = u345;
         local v1040;
         if (v1032 < 0.5) then
            v1040 = 1;
         else
            if (v1032 < 3.5) then
               v1040 = 0;
            else
               local v1041 = false;
               if (v1032 < 4) then
                  v1040 = (v1032 - 3.5) / 0.5;
                  if (not v1040) then
                     v1041 = true;
                  end
               else
                  v1041 = true;
               end
               if (v1041) then
                  v1040 = 1;
               end
            end
         end
         v1039.TextTransparency = v1040;
         if (v1032 > 4) then
            u341:disconnect();
            u346:Destroy();
            spawn(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u347
                     2 => f_unlockedgun
   
               --]]
               if (u347) then
                  local v1042 = 1;
                  local v1043 = #u347;
                  local v1044 = v1043;
                  local v1045 = v1042;
                  if (not (v1043 <= v1045)) then
                     while true do
                        f_unlockedgun(u347[v1042]);
                        wait(3);
                        local v1046 = v1042 + 1;
                        v1042 = v1046;
                        local v1047 = v1044;
                        if (v1047 < v1046) then
                           break;
                        end
                     end
                  end
               end
            end);
         end
      end);
   end;
   local t_WaitForChild_143 = v856;
   local t_PlayerGui_144 = v867;
   local t_FindFirstChild_145 = v857;
   local f_reset;
   f_reset = function(p211)
      --[[
         Name: reset
         Upvalues: 
            1 => u310
            2 => t_WaitForChild_143
            3 => t_PlayerGui_144
            4 => u311
            5 => u312
            6 => t_FindFirstChild_145
   
      --]]
      u310 = t_WaitForChild_143(t_PlayerGui_144, "MainGui");
      u311 = t_WaitForChild_143(u310, "GameGui");
      u312 = t_WaitForChild_143(u311, "NotifyList");
      if (t_FindFirstChild_145(u310, "KillBar")) then
         u310.KillBar:Destroy();
      end
   end;
   v8.reset = f_reset;
   v18:add("unlockweapon", f_unlockedgun);
   local v1048 = CFrame.new().toObjectSpace;
   local v1049 = BrickColor.new;
   local v1050 = game.ReplicatedStorage.AttachmentModels;
   local t_FindFirstChild_146 = v857;
   local u348 = v864;
   local f_hideparts;
   f_hideparts = function(p212, p213, p214)
      --[[
         Name: hideparts
         Upvalues: 
            1 => t_FindFirstChild_146
            2 => u348
   
      --]]
      local v1051 = p212:GetChildren();
      local v1052 = v1051;
      local v1053 = nil;
      local v1054 = 1;
      local v1055 = #v1051;
      local v1056 = v1055;
      local v1057 = v1054;
      if (not (v1055 <= v1057)) then
         while true do
            local v1058 = false;
            if (p213 == "Optics") then
               local v1059 = false;
               local t_Name_149 = v1052[v1054].Name;
               if (t_Name_149 == "Iron") then
                  v1059 = true;
               else
                  local t_Name_152 = v1052[v1054].Name;
                  if (t_Name_152 == "IronGlow") then
                     v1059 = true;
                  else
                     local t_Name_150 = v1052[v1054].Name;
                     if ((t_Name_150 == "SightMark") and t_FindFirstChild_146(v1052[v1054], "Decal")) then
                        local t_Decal_151 = v1052[v1054].Decal;
                        local v1060;
                        if (p214) then
                           v1060 = 1;
                        else
                           v1060 = 0;
                        end
                        t_Decal_151.Transparency = v1060;
                        v1058 = true;
                     else
                        v1058 = true;
                     end
                  end
               end
               if (v1059) then
                  if (p214 and (not t_FindFirstChild_146(v1052[v1054], "Hide"))) then
                     local v1061 = u348("IntValue");
                     v1061.Name = "Hide";
                     v1061.Parent = v1052[v1054];
                  else
                     local v1062 = t_FindFirstChild_146(v1052[v1054], "Hide");
                     local v1063 = v1062;
                     if (v1062) then
                        v1063:Destroy();
                     end
                  end
                  local v1064 = v1052[v1054];
                  local v1065;
                  if (p214) then
                     v1065 = 1;
                  else
                     v1065 = 0;
                  end
                  v1064.Transparency = v1065;
                  v1058 = true;
               end
            else
               if (p213 == "Underbarrel") then
                  local t_Name_148 = v1052[v1054].Name;
                  if (t_Name_148 == "Grip") then
                     if (p214 and (not t_FindFirstChild_146(v1052[v1054], "Hide"))) then
                        local v1066 = u348("IntValue");
                        v1066.Name = "Hide";
                        v1066.Parent = v1052[v1054];
                     else
                        local v1067 = t_FindFirstChild_146(v1052[v1054], "Hide");
                        local v1068 = v1067;
                        if (v1067) then
                           v1068:Destroy();
                        end
                     end
                     local v1069 = v1052[v1054];
                     local v1070;
                     if (p214) then
                        v1070 = 1;
                     else
                        v1070 = 0;
                     end
                     v1069.Transparency = v1070;
                     local v1071 = t_FindFirstChild_146(v1052[v1054], "Slot1");
                     if (not v1071) then
                        v1071 = t_FindFirstChild_146(v1052[v1054], "Slot2");
                     end
                     v1053 = v1071;
                     v1058 = true;
                  else
                     v1058 = true;
                  end
               else
                  if (p213 == "Barrel") then
                     local t_Name_147 = v1052[v1054].Name;
                     if (t_Name_147 == "Barrel") then
                        if (p214 and (not t_FindFirstChild_146(v1052[v1054], "Hide"))) then
                           local v1072 = u348("IntValue");
                           v1072.Name = "Hide";
                           v1072.Parent = v1052[v1054];
                        else
                           local v1073 = t_FindFirstChild_146(v1052[v1054], "Hide");
                           local v1074 = v1073;
                           if (v1073) then
                              v1074:Destroy();
                           end
                        end
                        local v1075 = v1052[v1054];
                        local v1076;
                        if (p214) then
                           v1076 = 1;
                        else
                           v1076 = 0;
                        end
                        v1075.Transparency = v1076;
                        local v1077 = t_FindFirstChild_146(v1052[v1054], "Slot1");
                        if (not v1077) then
                           v1077 = t_FindFirstChild_146(v1052[v1054], "Slot2");
                        end
                        v1053 = v1077;
                        v1058 = true;
                     else
                        v1058 = true;
                     end
                  else
                     v1058 = true;
                  end
               end
            end
            if (v1058) then
               local v1078 = v1054 + 1;
               v1054 = v1078;
               local v1079 = v1056;
               if (v1079 < v1078) then
                  break;
               end
            end
         end
      end
      return v1053;
   end;
   local t_FindFirstChild_153 = v857;
   local u349 = v859;
   local u350 = v864;
   local u351 = v1049;
   local u352 = v316;
   local f_texturekcmodel;
   f_texturekcmodel = function(p215, p216, p217, p218)
      --[[
         Name: texturekcmodel
         Upvalues: 
            1 => t_FindFirstChild_153
            2 => u349
            3 => u350
            4 => u351
            5 => u352
   
      --]]
      local v1080 = p217;
      local g_next_154 = next;
      local v1081, v1082 = p215:GetChildren();
      local v1083 = v1081;
      local v1084 = v1082;
      while true do
         local v1085, v1086 = g_next_154(v1083, v1084);
         local v1087 = v1085;
         local v1088 = v1086;
         if (v1085) then
            v1084 = v1087;
            if (p218 and v1088:IsA("BasePart")) then
               local t_Name_160 = v1088.Name;
               if (t_Name_160 == "LaserLight") then
                  v1088.Material = "SmoothPlastic";
                  if (t_FindFirstChild_153(v1088, "Bar")) then
                     v1088.Bar.Scale = u349(0.1, 1000, 0.1);
                  end
               end
            end
            if ((t_FindFirstChild_153(v1088, "Mesh") or v1088:IsA("UnionOperation")) or v1088:IsA("MeshPart")) then
               v1088.Anchored = true;
               local v1089 = t_FindFirstChild_153(v1088, "Slot1");
               if (not v1089) then
                  v1089 = t_FindFirstChild_153(v1088, "Slot2");
               end
               if (v1089) then
                  local g_next_155 = next;
                  local v1090, v1091 = v1088:GetChildren();
                  local v1092 = v1090;
                  local v1093 = v1091;
                  while true do
                     local v1094, v1095 = g_next_155(v1092, v1093);
                     local v1096 = v1094;
                     local v1097 = v1095;
                     if (v1094) then
                        v1093 = v1096;
                        if (v1097:IsA("Texture")) then
                           v1097:Destroy();
                        end
                     else
                        break;
                     end
                  end
                  if (v1080 and v1080[v1089.Name]) then
                     local t_Name_156 = v1080[v1089.Name].Name;
                     if (t_Name_156 ~= "") then
                        local t_BrickProperties_157 = v1080[v1089.Name].BrickProperties;
                        local v1098 = v1080[v1089.Name].TextureProperties;
                        local t_TextureProperties_158 = v1098;
                        local v1099 = u350("Texture");
                        local v1100 = v1099;
                        v1099.Name = v1089.Name;
                        v1099.Texture = "rbxassetid://" .. v1098.TextureId;
                        local t_Transparency_159 = v1088.Transparency;
                        local v1101;
                        if (t_Transparency_159 >= 0.8) then
                           v1101 = 1;
                        else
                           v1101 = t_TextureProperties_158.Transparency;
                           if (not v1101) then
                              v1101 = 0;
                           end
                        end
                        v1100.Transparency = v1101;
                        v1100.StudsPerTileU = t_TextureProperties_158.StudsPerTileU or 1;
                        v1100.StudsPerTileV = t_TextureProperties_158.StudsPerTileV or 1;
                        v1100.OffsetStudsU = t_TextureProperties_158.OffsetStudsU or 0;
                        v1100.OffsetStudsV = t_TextureProperties_158.OffsetStudsV or 0;
                        if (t_TextureProperties_158.Color) then
                           local v1102 = t_TextureProperties_158.Color;
                           v1100.Color3 = Color3.new(v1102.r / 255, v1102.g / 255, v1102.b / 255);
                        end
                        local v1103 = 0;
                        local v1104;
                        if (v1088:IsA("MeshPart") or v1088:IsA("UnionOperation")) then
                           v1104 = 5;
                        else
                           v1104 = 0;
                        end
                        local v1105 = v1103;
                        local v1106 = v1104;
                        if (not (v1106 <= v1105)) then
                           while true do
                              local v1107 = v1100:Clone();
                              v1107.Face = v1103;
                              v1107.Parent = v1088;
                              local v1108 = v1103 + 1;
                              v1103 = v1108;
                              local v1109 = v1104;
                              if (v1109 < v1108) then
                                 break;
                              end
                           end
                        end
                        v1100:Destroy();
                        if (not t_BrickProperties_157.DefaultColor) then
                           if (v1088:IsA("UnionOperation")) then
                              v1088.UsePartColor = true;
                           end
                           if (t_BrickProperties_157.Color) then
                              local v1110 = t_BrickProperties_157.Color;
                              v1088.Color = Color3.new(v1110.r / 255, v1110.g / 255, v1110.b / 255);
                           else
                              if (t_BrickProperties_157.BrickColor) then
                                 v1088.BrickColor = u351(t_BrickProperties_157.BrickColor);
                              end
                           end
                        end
                        if (t_BrickProperties_157.Material) then
                           v1088.Material = t_BrickProperties_157.Material;
                        end
                        if (t_BrickProperties_157.Reflectance) then
                           v1088.Reflectance = t_BrickProperties_157.Reflectance;
                        end
                     end
                  end
               end
            else
               if (v1088:IsA("Model")) then
                  u352(v1088, p216, p217, p218);
               end
            end
         else
            break;
         end
      end
   end;
   local t_FindFirstChild_161 = v857;
   local t_AttachmentModels_162 = v1050;
   local t_WaitForChild_163 = v856;
   local t_toObjectSpace_164 = v1048;
   local f_hideparts = f_hideparts;
   local u353 = v864;
   local f_updategunattachment;
   f_updategunattachment = function(p219, p220, p221, p222, p223)
      --[[
         Name: updategunattachment
         Upvalues: 
            1 => f_gunrequire
            2 => t_FindFirstChild_161
            3 => t_AttachmentModels_162
            4 => t_WaitForChild_163
            5 => t_toObjectSpace_164
            6 => f_hideparts
            7 => u353
   
      --]]
      local v1111 = false;
      local v1112 = p219:GetChildren();
      local v1113 = f_gunrequire(p219.Name);
      local v1114 = v1113;
      local v1115;
      if (v1113.attachments[p220]) then
         v1115 = v1114.attachments[p220][p221];
         if (not v1115) then
            v1111 = true;
         end
      else
         v1111 = true;
      end
      if (v1111) then
         v1115 = {};
      end
      local v1116 = false;
      local v1117;
      if (v1115.altmodel) then
         v1117 = t_FindFirstChild_161(t_AttachmentModels_162, v1115.altmodel);
         if (not v1117) then
            v1116 = true;
         end
      else
         v1116 = true;
      end
      if (v1116) then
         v1117 = t_FindFirstChild_161(t_AttachmentModels_162, p221);
      end
      if (not v1117) then
         return;
      end
      local v1118 = v1117:Clone();
      local v1119 = v1118;
      local v1120 = t_WaitForChild_163(v1118, "Node");
      local v1121 = v1115.sidemount;
      if (v1121) then
         v1121 = t_AttachmentModels_162[v1115.sidemount]:Clone();
      end
      v1119.Name = p221;
      local v1142;
      if (v1121) then
         local v1122 = false;
         local t_Node_169 = v1121.Node;
         local v1123;
         if (v1115.mountnode) then
            v1123 = p222[v1115.mountnode];
            if (not v1123) then
               v1122 = true;
            end
         else
            v1122 = true;
         end
         if (v1122) then
            local v1124 = false;
            if (p220 == "Optics") then
               v1123 = p222.MountNode;
               if (not v1123) then
                  v1124 = true;
               end
            else
               v1124 = true;
            end
            if (v1124) then
               v1123 = false;
               if (p220 == "Underbarrel") then
                  v1123 = p222.UnderMountNode;
               end
            end
         end
         local v1125 = {};
         local v1126 = v1121:GetChildren();
         local v1127 = v1126;
         local t_CFrame_170 = t_Node_169.CFrame;
         local v1128 = 1;
         local v1129 = #v1126;
         local v1130 = v1129;
         local v1131 = v1128;
         if (not (v1129 <= v1131)) then
            while true do
               if (v1127[v1128]:IsA("BasePart")) then
                  v1125[v1128] = t_toObjectSpace_164(t_CFrame_170, v1127[v1128].CFrame);
               end
               local v1132 = v1128 + 1;
               v1128 = v1132;
               local v1133 = v1130;
               if (v1133 < v1132) then
                  break;
               end
            end
         end
         t_Node_169.CFrame = v1123.CFrame;
         local v1134 = 1;
         local v1135 = #v1127;
         local v1136 = v1135;
         local v1137 = v1134;
         if (not (v1135 <= v1137)) then
            while true do
               if (v1127[v1134]:IsA("BasePart")) then
                  v1127[v1134].CFrame = v1123.CFrame * v1125[v1134];
               end
               local v1138 = v1134 + 1;
               v1134 = v1138;
               local v1139 = v1136;
               if (v1139 < v1138) then
                  break;
               end
            end
         end
         local v1140 = false;
         local v1141;
         if (v1115.node) then
            v1141 = p222[v1115.node];
            if (not v1141) then
               v1140 = true;
            end
         else
            v1140 = true;
         end
         if (v1140) then
            v1141 = v1121[p220 .. "Node"];
         end
         v1142 = v1141;
         v1121.Parent = v1119;
      else
         local v1143 = false;
         local v1144;
         if (v1115.node) then
            v1144 = p222[v1115.node];
            if (not v1144) then
               v1143 = true;
            end
         else
            v1143 = true;
         end
         if (v1143) then
            v1144 = p222[p220 .. "Node"];
         end
         v1142 = v1144;
      end
      if (v1115.auxmodels) then
         local v1145 = {};
         local g_next_165 = next;
         local t_auxmodels_166 = v1115.auxmodels;
         local v1146 = nil;
         while true do
            local v1147, v1148 = g_next_165(t_auxmodels_166, v1146);
            local v1149 = v1147;
            local v1150 = v1148;
            if (v1147) then
               v1146 = v1149;
               local v1151 = v1150.Name;
               if (not v1151) then
                  v1151 = p221 .. (" " .. v1150.PostName);
               end
               local v1152 = t_AttachmentModels_162[v1151]:Clone();
               local v1153 = v1152;
               local t_Node_167 = v1152.Node;
               v1145[v1151] = v1152;
               local v1154;
               if (v1150.sidemount and v1121) then
                  v1154 = v1121[v1150.Node];
               else
                  if ((v1150.auxmount and v1145[v1150.auxmount]) and t_FindFirstChild_161(v1145[v1150.auxmount], v1150.Node)) then
                     v1154 = v1145[v1150.auxmount][v1150.Node];
                  else
                     v1154 = p222[v1150.Node];
                  end
               end
               if (v1150.mainnode) then
                  v1142 = v1153[v1150.mainnode];
               end
               local v1155 = {};
               local v1156 = v1153:GetChildren();
               local v1157 = v1156;
               local t_CFrame_168 = t_Node_167.CFrame;
               local v1158 = 1;
               local v1159 = #v1156;
               local v1160 = v1159;
               local v1161 = v1158;
               if (not (v1159 <= v1161)) then
                  while true do
                     if (v1157[v1158]:IsA("BasePart")) then
                        v1155[v1158] = t_toObjectSpace_164(t_CFrame_168, v1157[v1158].CFrame);
                     end
                     local v1162 = v1158 + 1;
                     v1158 = v1162;
                     local v1163 = v1160;
                     if (v1163 < v1162) then
                        break;
                     end
                  end
               end
               t_Node_167.CFrame = v1154.CFrame;
               local v1164 = 1;
               local v1165 = #v1157;
               local v1166 = v1165;
               local v1167 = v1164;
               if (not (v1165 <= v1167)) then
                  while true do
                     if (v1157[v1164]:IsA("BasePart")) then
                        v1157[v1164].CFrame = v1154.CFrame * v1155[v1164];
                     end
                     local v1168 = v1164 + 1;
                     v1164 = v1168;
                     local v1169 = v1166;
                     if (v1169 < v1168) then
                        break;
                     end
                  end
               end
               v1153.Parent = v1119;
            else
               break;
            end
         end
      end
      local v1170 = {};
      local v1171 = v1119:GetChildren();
      local v1172 = v1120;
      if (v1172) then
         v1172 = v1120.CFrame;
      end
      local v1173 = f_hideparts(p219, p220, true);
      local v1174 = 1;
      local v1175 = #v1171;
      local v1176 = v1175;
      local v1177 = v1174;
      if (not (v1175 <= v1177)) then
         while true do
            if (v1171[v1174]:IsA("BasePart")) then
               v1170[v1174] = t_toObjectSpace_164(v1172, v1171[v1174].CFrame);
            end
            local v1178 = v1174 + 1;
            v1174 = v1178;
            local v1179 = v1176;
            if (v1179 < v1178) then
               break;
            end
         end
      end
      local v1180 = 1;
      local v1181 = #v1112;
      local v1182 = v1181;
      local v1183 = v1180;
      if (not (v1181 <= v1183)) then
         while true do
            local v1184 = v1112[v1180];
            local v1185 = v1184;
            if (v1115.transparencymod and v1115.transparencymod[v1184.Name]) then
               local v1186 = u353("IntValue");
               v1186.Parent = v1185;
               v1186.Name = p220 .. "Hide";
               v1186.Value = v1185.Transparency;
               v1185.Transparency = v1115.transparencymod[v1185.Name];
            end
            local v1187 = v1180 + 1;
            v1180 = v1187;
            local v1188 = v1182;
            if (v1188 < v1187) then
               break;
            end
         end
      end
      v1120.CFrame = v1142.CFrame;
      local v1189 = 1;
      local v1190 = #v1171;
      local v1191 = v1190;
      local v1192 = v1189;
      if (not (v1190 <= v1192)) then
         while true do
            if (v1171[v1189]:IsA("BasePart")) then
               local v1193 = v1171[v1189];
               local v1194 = v1193;
               v1193.CFrame = v1142.CFrame * v1170[v1189];
               if (v1173 and ((t_FindFirstChild_161(v1193, "Mesh") or v1193:IsA("UnionOperation")) or v1193:IsA("MeshPart"))) then
                  (v1173:Clone()).Parent = v1194;
               end
            end
            local v1195 = v1189 + 1;
            v1189 = v1195;
            local v1196 = v1191;
            if (v1196 < v1195) then
               break;
            end
         end
      end
      v1119.Parent = p219;
   end;
   local t_WaitForChild_171 = v856;
   local f_updategunattachment = f_updategunattachment;
   local f_texturekcmodel = f_texturekcmodel;
   local u354 = v18;
   local f_getgunmodel;
   f_getgunmodel = function(p224, p225, p226)
      --[[
         Name: getgunmodel
         Upvalues: 
            1 => t_getGunModel_3
            2 => t_WaitForChild_171
            3 => f_updategunattachment
            4 => f_texturekcmodel
            5 => u354
   
      --]]
      local v1197 = t_getGunModel_3(p224);
      local v1198 = v1197;
      if (not v1197) then
         u354:send("debug", "Failed to find weapon model for", p224);
         error("Failed to find weapon model for", p224);
         return;
      end
      local v1199 = v1198:Clone();
      local v1200 = v1199;
      local v1201 = t_WaitForChild_171(v1199, "MenuNodes");
      local v1202 = v1201;
      v1201.Parent = v1199;
      v1199.PrimaryPart = t_WaitForChild_171(v1201, "MenuNode");
      if (p225) then
         local g_next_172 = next;
         local v1203 = p225;
         local v1204 = nil;
         while true do
            local v1205, v1206 = g_next_172(v1203, v1204);
            local v1207 = v1205;
            local v1208 = v1206;
            if (v1205) then
               v1204 = v1207;
               if (v1208 ~= "") then
                  f_updategunattachment(v1200, v1207, v1208, v1202);
               end
            else
               break;
            end
         end
      end
      f_texturekcmodel(v1200, p225, p226, true);
      return v1200;
   end;
   local u355 = v30;
   local t_LocalPlayer_173 = v865;
   local t_KillBar_174 = v870;
   local t_FindFirstChild_175 = v857;
   local u356 = v864;
   local u357 = v11;
   local u358 = v7;
   v18:add("killed", function(p227, p228, p229, p230, p231, p232, p233)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u355
            2 => t_LocalPlayer_173
            3 => t_KillBar_174
            4 => u310
            5 => f_getgunmodel
            6 => t_FindFirstChild_175
            7 => u356
            8 => u357
            9 => u358
   
      --]]
      local t_cframe_176 = u355.cframe;
      local v1209 = t_LocalPlayer_173;
      if (p227 == v1209) then
         u355:setfixedcam(CFrame.new(t_cframe_176.p, t_cframe_176.p + t_cframe_176.lookVector));
         return;
      end
      local v1210 = t_KillBar_174:Clone();
      local v1211 = v1210;
      v1210.Killer.Label.Text = p228;
      v1210.Weapon.Label.Text = p230;
      v1210.Parent = u310;
      v1210.Rank.Label.Text = p231;
      local v1212 = f_getgunmodel(p229, p232, p233);
      local v1213 = v1212;
      local v1214 = t_FindFirstChild_175(v1212.MenuNodes, "ViewportNode");
      if (not v1214) then
         v1214 = v1213.MenuNodes.MenuNode;
      end
      v1213.PrimaryPart = v1214;
      v1213:SetPrimaryPartCFrame(CFrame.new(0, 0, 0));
      local v1215 = u356("Camera");
      v1215.CFrame = CFrame.new(((v1214.CFrame.p + (v1214.CFrame.RightVector * -7)) + (v1214.CFrame.lookVector * 4)) + (v1214.CFrame.upVector * 4), v1214.CFrame.p + (v1214.CFrame.lookVector * 1.5));
      v1215.FieldOfView = 16;
      v1215.Parent = v1213;
      v1213.Parent = v1211.WeaponViewport;
      v1211.WeaponViewport.CurrentCamera = v1215;
      local g_next_177 = next;
      local v1216, v1217 = v1211.Attachments:GetChildren();
      local v1218 = v1216;
      local v1219 = v1217;
      while true do
         local v1220, v1221 = g_next_177(v1218, v1219);
         local v1222 = v1220;
         local v1223 = v1221;
         if (v1220) then
            v1219 = v1222;
            v1223.Type.Text = "None";
         else
            break;
         end
      end
      if (p232) then
         local g_next_179 = next;
         local v1224 = p232;
         local v1225 = nil;
         while true do
            local v1226, v1227 = g_next_179(v1224, v1225);
            local v1228 = v1226;
            local v1229 = v1227;
            if (v1226) then
               v1225 = v1228;
               if (not ((v1228 == "Name") or (v1229 == ""))) then
                  v1211.Attachments[v1228].Type.Text = u357.getattdisplayname(v1229);
               end
            else
               break;
            end
         end
      end
      if (u358:isplayeralive(p227)) then
         u355:setspectate(p227);
      else
         u355:setfixedcam(CFrame.new(t_cframe_176.p, t_cframe_176.p + t_cframe_176.lookVector));
      end
      local g_delay_178 = delay;
      local u359 = v1213;
      g_delay_178(5, function()
         --[[
            Name: (empty)
            Upvalues: 
               1 => u359
   
         --]]
         u359:Destroy();
      end);
   end);
   v18:add("unlockedattach", f_unlockedattach);
   v18:add("rankup", f_rankup);
   local f_bigaward = f_bigaward;
   v18:add("bigaward", function(p234, p235, p236, p237)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_bigaward
   
      --]]
      f_bigaward(p234, p235, p236, p237);
   end);
   local f_smallaward = f_smallaward;
   v18:add("smallaward", function(p238, p239)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_smallaward
   
      --]]
      f_smallaward(p238, p239);
   end);
   v18:add("newevent", f_customevent);
   local u360 = v6;
   v18:add("newroundid", function(p240)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u360
   
      --]]
      u360.updateversionstr(p240);
   end);
   local u361 = v5;
   local t_FindFirstChild_180 = v857;
   local u362 = v7;
   local u363 = v860;
   local f_step;
   f_step = function()
      --[[
         Name: step
         Upvalues: 
            1 => u361
            2 => t_FindFirstChild_180
            3 => u310
            4 => u362
            5 => u363
   
      --]]
      if (not u361.alive) then
         local v1230 = t_FindFirstChild_180(u310, "KillBar");
         local v1231 = v1230;
         if (v1230) then
            local v1232 = t_FindFirstChild_180(game:GetService("Players"), v1231.Killer.Label.Text);
            local v1233 = v1232;
            if (v1232) then
               local v1234 = false;
               local v1235 = u362:getplayerhealth(v1233);
               local v1236 = v1235;
               v1231.Health.Label.Text = math.ceil(v1235);
               local t_Label_181 = v1231.Health.Label;
               local v1237;
               if (v1235 < 20) then
                  v1237 = u363(1, 0, 0);
                  if (not v1237) then
                     v1234 = true;
                  end
               else
                  v1234 = true;
               end
               if (v1234) then
                  local v1238 = false;
                  if (v1236 < 50) then
                     v1237 = u363(1, 1, 0);
                     if (not v1237) then
                        v1238 = true;
                     end
                  else
                     v1238 = true;
                  end
                  if (v1238) then
                     v1237 = u363(0, 1, 0);
                  end
               end
               t_Label_181.TextColor3 = v1237;
               return;
            end
            v1231.Health.Label.Text = 100;
            v1231.Health.Label.TextColor3 = u363(0, 1, 0);
         end
      end
   end;
   v8.step = f_step;
   print("Loading leaderboard module");
   local v1239 = game.WaitForChild;
   local v1240 = game.FindFirstChild;
   local v1241 = UDim2.new;
   local v1242 = CFrame.new;
   local v1243 = Vector3.new;
   local v1244 = Color3.new;
   local v1245 = Vector3.new().Dot;
   local v1246 = Ray.new;
   local v1247 = Instance.new;
   local v1248 = workspace.FindPartOnRayWithIgnoreList;
   local v1249 = game.IsA;
   local v1250 = game:GetService("Players");
   local v1251 = v1250.LocalPlayer;
   local v1252 = game.ReplicatedStorage.Character.PlayerTag;
   local v1253 = v1251.PlayerGui;
   local v1254 = game.ReplicatedStorage.Misc.Player;
   local v1255 = v1239(v1253, "Leaderboard");
   local v1256 = v1239(v1255, "Main");
   local v1257 = v1256;
   local v1258 = v1239(v1256, "TopBar");
   local v1259 = v1239(v1255, "Global");
   local v1260 = v1239(v1258, "Ping");
   local v1261 = v1239(v1256, "Ghosts");
   local v1262 = v1239(v1256, "Phantoms");
   local v1263 = v1239(v1261, "DataFrame");
   local v1264 = v1239(v1262, "DataFrame");
   local v1265 = v1239(v1263, "Data");
   local v1266 = v1239(v1264, "Data");
   local u364 = v1265;
   local u365 = v1266;
   local t_FindFirstChild_182 = v1240;
   local u366 = v1241;
   local t_LocalPlayer_183 = v1251;
   local u367 = v1244;
   local f_organize;
   f_organize = function()
      --[[
         Name: organize
         Upvalues: 
            1 => u364
            2 => u365
            3 => t_FindFirstChild_182
            4 => u366
            5 => t_LocalPlayer_183
            6 => u367
   
      --]]
      local v1267 = game:GetService("Players"):GetPlayers();
      local v1268 = v1267;
      local v1269 = 1;
      local v1270 = #v1267;
      local v1271 = v1270;
      local v1272 = v1269;
      if (not (v1270 <= v1272)) then
         while true do
            local v1273 = false;
            local v1274 = v1268[v1269];
            local v1275 = v1274;
            local v1276 = v1274.TeamColor;
            local t_TeamColor_186 = game.Teams.Ghosts.TeamColor;
            local v1277;
            if (v1276 == t_TeamColor_186) then
               v1277 = u364;
               if (not v1277) then
                  v1273 = true;
               end
            else
               v1273 = true;
            end
            if (v1273) then
               v1277 = u365;
            end
            local v1278 = false;
            local v1279 = v1275.TeamColor;
            local t_TeamColor_187 = game.Teams.Ghosts.TeamColor;
            local v1280;
            if (v1279 == t_TeamColor_187) then
               v1278 = true;
            else
               v1280 = u364;
               if (not v1280) then
                  v1278 = true;
               end
            end
            if (v1278) then
               v1280 = u365;
            end
            local v1281 = t_FindFirstChild_182(v1277, v1275.Name);
            local v1282 = t_FindFirstChild_182(v1280, v1275.Name);
            local v1283 = v1282;
            if ((not v1281) and v1282) then
               v1283.Parent = v1277;
            end
            local v1284 = v1269 + 1;
            v1269 = v1284;
            local v1285 = v1271;
            if (v1285 < v1284) then
               break;
            end
         end
      end
      local v1286 = u364:GetChildren();
      local v1287 = v1286;
      table.sort(v1286, function(p241, p242)
         --[[
            Name: (empty)
         --]]
         return tonumber(p242.Score.Text) < tonumber(p241.Score.Text);
      end);
      local v1288 = 1;
      local v1289 = #v1286;
      local v1290 = v1289;
      local v1291 = v1288;
      if (not (v1289 <= v1291)) then
         while true do
            local v1292 = v1287[v1288];
            local v1293 = v1292;
            v1292.Position = u366(0, 0, 0, v1288 * 25);
            local v1294 = v1292.Name;
            local t_Name_185 = t_LocalPlayer_183.Name;
            if (v1294 == t_Name_185) then
               v1293.Username.TextColor3 = u367(1, 1, 0);
            end
            local v1295 = v1288 + 1;
            v1288 = v1295;
            local v1296 = v1290;
            if (v1296 < v1295) then
               break;
            end
         end
      end
      u364.Parent.CanvasSize = u366(0, 0, 0, ((#v1287) + 1) * 25);
      local v1297 = u365:GetChildren();
      local v1298 = v1297;
      table.sort(v1297, function(p243, p244)
         --[[
            Name: (empty)
         --]]
         return tonumber(p244.Score.Text) < tonumber(p243.Score.Text);
      end);
      local v1299 = 1;
      local v1300 = #v1297;
      local v1301 = v1300;
      local v1302 = v1299;
      if (not (v1300 <= v1302)) then
         while true do
            local v1303 = v1298[v1299];
            local v1304 = v1303;
            v1303.Position = u366(0, 0, 0, v1299 * 25);
            local v1305 = v1303.Name;
            local t_Name_184 = t_LocalPlayer_183.Name;
            if (v1305 == t_Name_184) then
               v1304.Username.TextColor3 = u367(1, 1, 0);
            end
            local v1306 = v1299 + 1;
            v1299 = v1306;
            local v1307 = v1301;
            if (v1307 < v1306) then
               break;
            end
         end
      end
      u365.Parent.CanvasSize = u366(0, 0, 0, ((#v1298) + 1) * 25);
   end;
   local t_FindFirstChild_188 = v1240;
   local u368 = v1265;
   local u369 = v1266;
   local t_Player_189 = v1254;
   local t_LocalPlayer_190 = v1251;
   local u370 = v1244;
   local f_organize = f_organize;
   local f_addplayer;
   f_addplayer = function(p245)
      --[[
         Name: addplayer
         Upvalues: 
            1 => t_FindFirstChild_188
            2 => u368
            3 => u369
            4 => t_Player_189
            5 => t_LocalPlayer_190
            6 => u370
            7 => f_organize
   
      --]]
      if (t_FindFirstChild_188(u368, p245.Name) or t_FindFirstChild_188(u369, p245.Name)) then
         return;
      end
      local v1308 = t_Player_189:Clone();
      local v1309 = v1308;
      v1308.Name = p245.Name;
      v1308.Username.Text = p245.Name;
      v1308.Kills.Text = 0;
      v1308.Deaths.Text = 0;
      v1308.Streak.Text = 0;
      v1308.Score.Text = 0;
      v1308.Kdr.Text = 0;
      v1308.Rank.Text = 0;
      local v1310 = t_LocalPlayer_190;
      if (p245 == v1310) then
         v1309.Username.TextColor3 = u370(1, 1, 0);
      end
      local v1311 = false;
      local v1312 = p245.TeamColor;
      local t_TeamColor_191 = game.Teams.Ghosts.TeamColor;
      local v1313;
      if (v1312 == t_TeamColor_191) then
         v1313 = u368;
         if (not v1313) then
            v1311 = true;
         end
      else
         v1311 = true;
      end
      if (v1311) then
         v1313 = u369;
      end
      v1309.Parent = v1313;
      f_organize();
   end;
   local t_FindFirstChild_192 = v1240;
   local u371 = v1265;
   local u372 = v1266;
   local f_organize = f_organize;
   local f_removeplayer;
   f_removeplayer = function(p246)
      --[[
         Name: removeplayer
         Upvalues: 
            1 => t_FindFirstChild_192
            2 => u371
            3 => u372
            4 => f_organize
   
      --]]
      local v1314 = t_FindFirstChild_192(u371, p246.Name);
      local v1315 = v1314;
      local v1316 = t_FindFirstChild_192(u372, p246.Name);
      if (v1314) then
         v1315:Destroy();
      end
      if (v1316) then
         v1316:Destroy();
      end
      f_organize();
   end;
   local u373 = v1265;
   local u374 = v1266;
   local f_organize = f_organize;
   local f_updatestats;
   f_updatestats = function(p247, p248)
      --[[
         Name: updatestats
         Upvalues: 
            1 => u373
            2 => u374
            3 => f_organize
   
      --]]
      local v1317 = false;
      local v1318 = p247.TeamColor;
      local t_TeamColor_193 = game.Teams.Ghosts.TeamColor;
      local v1319;
      if (v1318 == t_TeamColor_193) then
         v1319 = u373;
         if (not v1319) then
            v1317 = true;
         end
      else
         v1317 = true;
      end
      if (v1317) then
         v1319 = u374;
      end
      local v1320 = v1319:FindFirstChild(p247.Name);
      if (not v1320) then
         f_organize();
         v1320 = v1319:FindFirstChild(p247.Name);
      end
      if (v1320) then
         local g_next_194 = next;
         local v1321 = p248;
         local v1322 = nil;
         while true do
            local v1323, v1324 = g_next_194(v1321, v1322);
            local v1325 = v1323;
            local v1326 = v1324;
            if (v1323) then
               v1322 = v1325;
               v1320[v1325].Text = v1326;
            else
               break;
            end
         end
      end
      f_organize();
   end;
   local u375 = v1256;
   local f_show;
   f_show = function(p249)
      --[[
         Name: show
         Upvalues: 
            1 => u375
   
      --]]
      u375.Visible = true;
   end;
   v9.show = f_show;
   local u376 = v1256;
   local f_hide;
   f_hide = function(p250)
      --[[
         Name: hide
         Upvalues: 
            1 => u376
   
      --]]
      u376.Visible = false;
   end;
   v9.hide = f_hide;
   local u377 = v1250;
   local f_updatestats = f_updatestats;
   local f_organize = f_organize;
   local f_setupleaderboard;
   f_setupleaderboard = function(p251)
      --[[
         Name: setupleaderboard
         Upvalues: 
            1 => u377
            2 => f_updatestats
            3 => f_organize
   
      --]]
      local g_next_195 = next;
      local v1327 = p251;
      local v1328 = nil;
      while true do
         local v1329, v1330 = g_next_195(v1327, v1328);
         local v1331 = v1329;
         local v1332 = v1330;
         if (v1329) then
            v1328 = v1331;
            f_updatestats(u377:FindFirstChild(v1331), v1332);
         else
            break;
         end
      end
      f_organize();
   end;
   v18:add("updatestats", f_updatestats);
   v18:add("fillboard", f_setupleaderboard);
   v1250.PlayerAdded:connect(f_addplayer);
   v1250.PlayerRemoving:connect(f_removeplayer);
   local g_next_196 = next;
   local v1333, v1334 = v1250:GetPlayers();
   local v1335 = v1333;
   local v1336 = v1334;
   while true do
      local v1337, v1338 = g_next_196(v1335, v1336);
      local v1339 = v1337;
      local v1340 = v1338;
      if (v1337) then
         v1336 = v1339;
         f_addplayer(v1340);
      else
         break;
      end
   end
   local v1341 = game:GetService("UserInputService").InputBegan;
   local u378 = v33;
   local u379 = v1257;
   local u380 = v9;
   local f_organize = f_organize;
   v1341:connect(function(p252)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u378
            2 => u379
            3 => u380
            4 => f_organize
   
      --]]
      local v1342 = false;
      local v1343 = p252.KeyCode;
      local t_KeyCode_197 = v1343;
      local v1344 = Enum.KeyCode.Tab;
      if ((v1343 == v1344) and (not u378.iskeydown(Enum.KeyCode.LeftAlt))) then
         v1342 = true;
      else
         local v1345 = Enum.KeyCode.ButtonSelect;
         if (t_KeyCode_197 == v1345) then
            v1342 = true;
         end
      end
      if (v1342) then
         if (u379.Visible) then
            u380:hide();
            return;
         end
         f_organize();
         u380:show();
      end
   end);
   local u381 = 60;
   local u382 = tick();
   local u383 = v1257;
   local u384 = v1260;
   local u385 = v18;
   local f_step;
   f_step = function(p253)
      --[[
         Name: step
         Upvalues: 
            1 => u381
            2 => u383
            3 => u384
            4 => u382
            5 => u385
   
      --]]
      u381 = (0.95 * u381) + (0.05 / p253);
      if (u383.Visible and u384) then
         local v1346 = tick();
         if (u382 < v1346) then
            local v1347 = u381 - (u381 % 1);
            if (not (((v1347 == v1347) and (not (v1347 == -(1/0)))) and (not (v1347 == (1/0))))) then
               v1347 = 60;
               u381 = v1347;
            end
            u384.Text = "Server Avg Send Ping: " .. ((u385.serverping or 0) .. ("ms\nYour Send Ping: " .. ((u385.playerping or 0) .. ("ms\nAverage FPS: " .. v1347))));
            u382 = tick() + 1;
         end
      end
   end;
   v9.step = f_step;
   print("Loading char module");
   local v1348 = shared.require("WepScript");
   local v1349 = math.pi;
   local v1350 = v1349;
   local v1351 = v1349 * 2;
   local v1352 = math.sin;
   local v1353 = math.cos;
   local t_IsA_198 = game.IsA;
   local v1354 = Instance.new;
   local v1355 = v1354;
   local v1356 = game.WaitForChild;
   local t_FindFirstChild_199 = game.FindFirstChild;
   local t_GetChildren_200 = game.GetChildren;
   local v1357 = CFrame.new;
   local v1358 = v1357;
   local v1359 = v1357();
   local v1360 = v1359;
   local v1361 = v1359.vectorToWorldSpace;
   local v1362 = CFrame.Angles;
   local v1363 = Vector3.new;
   local v1364 = v1363;
   local v1365 = v1363();
   local v1366 = v1365;
   local v1367 = Ray.new;
   local t_Debris_201 = game.Debris;
   local t_Dot_202 = v1365.Dot;
   local v1368 = UDim2.new;
   local t_toObjectSpace_203 = v1357().toObjectSpace;
   local u386 = nil;
   local u387 = nil;
   local v1369 = {};
   local v1370 = game:GetService("Players").LocalPlayer;
   local t_LocalPlayer_204 = v1370;
   local t_PlayerGui_205 = v1370.PlayerGui;
   local v1371 = game.ReplicatedStorage;
   local t_ReplicatedStorage_206 = v1371;
   local v1372 = workspace:WaitForChild("Players");
   local v1373 = workspace:WaitForChild("Map");
   local t_AttachmentModels_207 = v1371.AttachmentModels;
   local v1374 = Enum.Material.Air;
   local t_soundfonts_208 = v41.soundfonts;
   local v1375 = v41.materialhitsound;
   local v1376 = {
      Enum.HumanoidStateType.Dead,
      Enum.HumanoidStateType.Flying,
      Enum.HumanoidStateType.Seated,
      Enum.HumanoidStateType.Ragdoll,
      Enum.HumanoidStateType.Physics,
      Enum.HumanoidStateType.Swimming,
      Enum.HumanoidStateType.GettingUp,
      Enum.HumanoidStateType.FallingDown,
      Enum.HumanoidStateType.PlatformStanding,
      Enum.HumanoidStateType.RunningNoPhysics,
      Enum.HumanoidStateType.StrafingNoPhysics
   };
   local v1377 = v1376;
   local v1378 = v31.new();
   local u388 = nil;
   local u389 = false;
   local u390 = false;
   local u391 = false;
   local u392 = false;
   local u393 = 0;
   local u394 = 14;
   local v1379 = v25.new();
   local v1380 = v25.new();
   local u395 = v1354("Humanoid");
   local v1381 = 1;
   local v1382 = #v1376;
   local v1383 = v1382;
   local v1384 = v1381;
   if (not (v1382 <= v1384)) then
      while true do
         u395:SetStateEnabled(v1377[v1381], false);
         local v1385 = v1381 + 1;
         v1381 = v1385;
         local v1386 = v1383;
         if (v1386 < v1385) then
            break;
         end
      end
   end
   u395.AutomaticScalingEnabled = false;
   u395.AutoRotate = false;
   u395.AutoJumpEnabled = false;
   u395.BreakJointsOnDeath = false;
   u395.HealthDisplayDistance = 0;
   u395.NameDisplayDistance = 0;
   u395.RequiresNeck = false;
   u395.RigType = Enum.HumanoidRigType.R6;
   local u396 = 0;
   local v1387 = v25.new();
   local v1388 = v1387;
   local v1389 = v25.new(1);
   local v1390 = v1389;
   v1389.s = 12;
   v1389.d = 0.95;
   local u397 = {};
   v5.unaimedfov = 80;
   v5.speed = 0;
   v5.distance = 0;
   v5.sprint = false;
   local u398 = v5;
   local f_setunaimedfov;
   f_setunaimedfov = function(p254)
      --[[
         Name: setunaimedfov
         Upvalues: 
            1 => u398
   
      --]]
      u398.unaimedfov = p254;
   end;
   v5.setunaimedfov = f_setunaimedfov;
   local f_isdirtyfloat;
   f_isdirtyfloat = function(p255)
      --[[
         Name: isdirtyfloat
      --]]
      local v1391 = true;
      if (p255 == p255) then
         v1391 = true;
         if (p255 ~= -(1/0)) then
            v1391 = p255 == (1/0);
         end
      end
      return v1391;
   end;
   local f_addgun;
   f_addgun = function(p256)
      --[[
         Name: addgun
         Upvalues: 
            1 => u396
            2 => u397
   
      --]]
      local v1392 = 1;
      local v1393 = u396;
      local v1394 = v1393;
      local v1395 = v1392;
      if (not (v1393 <= v1395)) then
         while (u397[v1392] ~= p256) do
            local v1396 = v1392 + 1;
            v1392 = v1396;
            local v1397 = v1394;
            if (v1397 < v1396) then
               break;
            end
         end
         warn("Error, tried to add gun twice");
         return;
      end
      u396 = u396 + 1;
      u397[u396] = p256;
      p256.id = u396;
      return u396;
   end;
   local f_removegun;
   f_removegun = function(p257)
      --[[
         Name: removegun
         Upvalues: 
            1 => u396
            2 => u397
   
      --]]
      local v1398 = nil;
      local v1399 = 1;
      local v1400 = u396;
      local v1401 = v1400;
      local v1402 = v1399;
      if (not (v1400 <= v1402)) then
         while (u397[v1399] ~= p257) do
            local v1403 = v1399 + 1;
            v1399 = v1403;
            local v1404 = v1401;
            if (v1404 < v1403) then
               break;
            end
         end
         v1398 = true;
      end
      if (not v1398) then
         warn("Error, tried to remove gun twice");
         return;
      end
      local v1405 = p257.id;
      local t_id_209 = v1405;
      p257.id = nil;
      u397[v1405] = u397[u396];
      u397[u396] = nil;
      u396 = u396 - 1;
      local v1406 = u397[v1405];
      local v1407 = v1406;
      if (v1406) then
         v1407.id = t_id_209;
      end
   end;
   local f_unloadguns;
   f_unloadguns = function()
      --[[
         Name: unloadguns
         Upvalues: 
            1 => u396
            2 => u397
   
      --]]
      u396 = 0;
      u397 = {};
   end;
   v5.unloadguns = f_unloadguns;
   local v1408 = v25.new(v1366);
   local v1409 = v1408;
   local v1410 = v25.new();
   local v1411 = v1410;
   local v1412 = v25.new(v1366);
   local v1413 = v1412;
   local v1414 = v25.new(0);
   local v1415 = v25.new(0);
   local v1416 = v25.new(0);
   local v1417 = v25.new(0);
   local v1418 = v1417;
   local v1419 = v25.new(1);
   local v1420 = v25.new(0);
   local v1421 = v1420;
   local u399 = 1;
   v1379.s = 12;
   v1379.d = 0.9;
   v1380.s = 12;
   v1380.d = 0.9;
   v1387.d = 0.9;
   v1408.s = 10;
   v1408.d = 0.75;
   v1410.s = 16;
   v1412.s = 16;
   v1414.s = 8;
   v1415.s = 8;
   v1416.s = 20;
   v1417.s = 8;
   v1419.s = 12;
   v1419.d = 0.75;
   v5.crouchspring = v1415;
   v5.pronespring = v1414;
   v5.slidespring = v1416;
   local v1422 = v1355("BodyVelocity");
   local v1423 = v1422;
   v1422.Name = "\n";
   local u400 = nil;
   local u401 = v25.new(u394);
   u401.s = 8;
   local u402 = v25.new(1.5);
   u402.s = 8;
   v5.acceleration = v1366;
   v1422.MaxForce = v1366;
   local u403 = "stand";
   local v1424 = v1364(0, -5, 0);
   local f_getslidecondition;
   f_getslidecondition = function()
      --[[
         Name: getslidecondition
         Upvalues: 
            1 => u401
            2 => u394
   
      --]]
      return (u394 * 1.2) < u401.p;
   end;
   v5.getslidecondition = f_getslidecondition;
   local f_updatewalkspeed;
   f_updatewalkspeed = function()
      --[[
         Name: updatewalkspeed
         Upvalues: 
            1 => u391
            2 => u401
            3 => u399
            4 => u394
            5 => u403
   
      --]]
      if (u391) then
         u401.t = (1.4 * u399) * u394;
         return;
      end
      local v1425 = u403;
      if (v1425 == "prone") then
         u401.t = (u399 * u394) / 4;
         return;
      end
      local v1426 = u403;
      if (v1426 == "crouch") then
         u401.t = (u399 * u394) / 2;
         return;
      end
      local v1427 = u403;
      if (v1427 == "stand") then
         u401.t = u399 * u394;
      end
   end;
   local u404 = v5;
   local u405 = v41;
   local u406 = v1414;
   local u407 = v1415;
   local u408 = v7;
   local u409 = v1364;
   local u410 = v1422;
   local u411 = v33;
   local u412 = v30;
   local u413 = v1366;
   local u414 = v18;
   local u415 = v1379;
   local f_setmovementmode;
   f_setmovementmode = function(p258, p259, p260)
      --[[
         Name: setmovementmode
         Upvalues: 
            1 => u404
            2 => u403
            3 => u405
            4 => u402
            5 => u406
            6 => u407
            7 => u401
            8 => u399
            9 => u394
            10 => u408
            11 => u393
            12 => u391
            13 => u386
            14 => u409
            15 => u395
            16 => u389
            17 => u410
            18 => u411
            19 => u412
            20 => u413
            21 => u414
            22 => u415
   
      --]]
      local t_movementmode_210 = u404.movementmode;
      u404.movementmode = p259;
      u403 = p259;
      if (p259 == "prone") then
         if (not (p260 or (t_movementmode_210 == p259))) then
            u405.play("stanceProne", 0.15);
         end
         u402.t = -1.5;
         u406.t = 1;
         u407.t = 0;
         u401.t = (u399 * u394) / 4;
         u408:setcrossscale(0.5);
         u393 = 0.25;
         if (p260 and u391) then
            local t_y_212 = u386.Velocity.y;
            if (t_y_212 > -5) then
               coroutine.wrap(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u386
                        2 => u409
   
                  --]]
                  local v1428 = u386.CFrame.lookVector;
                  u386.Velocity = (v1428 * 50) + u409(0, 40, 0);
                  wait(0.1);
                  u386.Velocity = (v1428 * 60) + u409(0, 30, 0);
                  wait(0.4);
                  u386.Velocity = (v1428 * 20) + u409(0, -10, 0);
               end)();
            end
         end
      else
         if (p259 == "crouch") then
            if (not (p260 or (t_movementmode_210 == p259))) then
               u405.play("stanceStandCrouch", 0.15);
            end
            local u416 = false;
            local v1429 = u404.getslidecondition();
            u402.t = 0;
            u406.t = 0;
            u407.t = 1;
            u401.t = (u399 * u394) / 2;
            u408:setcrossscale(0.75);
            u393 = 0.15;
            if (p260 and v1429) then
               local v1430 = u395:GetState();
               local v1431 = Enum.HumanoidStateType.Freefall;
               if (v1430 ~= v1431) then
                  u389 = true;
                  u405.play("slideStart", 0.25);
                  u404.slidespring.t = 1;
                  coroutine.wrap(function()
                     --[[
                        Name: (empty)
                        Upvalues: 
                           1 => u404
                           2 => u410
                           3 => u409
                           4 => u411
                           5 => u416
                           6 => u412
                           7 => u401
                           8 => u413
                           9 => u389
                           10 => u405
   
                     --]]
                     local v1432 = u404.rootpart;
                     local t_rootpart_211 = v1432;
                     local v1433 = v1432.Velocity.unit;
                     local v1434 = v1432.CFrame:VectorToObjectSpace(v1433);
                     u410.MaxForce = u409(40000, 10, 40000);
                     local v1435 = tick();
                     while true do
                        local v1436 = tick();
                        local v1437 = v1435 + 0.6666666666666666;
                        if (v1436 < v1437) then
                           local v1438 = ((tick() - v1435) * 30) / 0.6666666666666666;
                           if (u411.keyboard.down.leftshift or u411.controller.down.l3) then
                              if (u416) then
                                 break;
                              end
                              v1433 = u412.cframe:VectorToWorldSpace(v1434);
                           else
                              u416 = true;
                           end
                           u410.Velocity = v1433 * (40 - v1438);
                           game:GetService("RunService").RenderStepped:wait();
                        else
                           break;
                        end
                     end
                     u401.p = t_rootpart_211.Velocity.Magnitude;
                     u410.MaxForce = u413;
                     u410.Velocity = u413;
                     if (u389) then
                        u389 = false;
                        u405.play("slideEnd", 0.15);
                     end
                     u404.slidespring.t = 0;
                  end)();
               end
            end
         else
            if (p259 == "stand") then
               if (t_movementmode_210 ~= p259) then
                  u405.play("stanceStandCrouch", 0.15);
               end
               u402.t = 1.5;
               u406.t = 0;
               u407.t = 0;
               u401.t = u399 * u394;
               u408:setcrossscale(1);
               u393 = 0;
            end
         end
      end
      u414:send("stance", p259);
      u391 = false;
      u414:send("sprint", u391);
      u415.t = 0;
   end;
   local f_getstate;
   f_getstate = function()
      --[[
         Name: getstate
         Upvalues: 
            1 => u395
   
      --]]
      return u395:GetState();
   end;
   v5.getstate = f_getstate;
   local f_sprinting;
   f_sprinting = function()
      --[[
         Name: sprinting
         Upvalues: 
            1 => u391
   
      --]]
      return u391;
   end;
   v5.sprinting = f_sprinting;
   v5.setmovementmode = f_setmovementmode;
   local f_setbasewalkspeed;
   f_setbasewalkspeed = function(p261, p262)
      --[[
         Name: setbasewalkspeed
         Upvalues: 
            1 => u394
            2 => f_updatewalkspeed
   
      --]]
      u394 = p262;
      f_updatewalkspeed();
   end;
   v5.setbasewalkspeed = f_setbasewalkspeed;
   local u417 = v13;
   local u418 = v41;
   local f_setmovementmode = f_setmovementmode;
   local u419 = v18;
   local u420 = v1379;
   local u421 = v33;
   local f_setsprint;
   f_setsprint = function(p263, p264)
      --[[
         Name: setsprint
         Upvalues: 
            1 => u417
            2 => u389
            3 => u418
            4 => f_setmovementmode
            5 => u391
            6 => u419
            7 => u399
            8 => u390
            9 => u392
            10 => u420
            11 => u401
            12 => u394
            13 => u421
   
      --]]
      local t_currentgun_213 = u417.currentgun;
      if (not p264) then
         if (u391) then
            u391 = false;
            u419:send("sprint", u391);
            u420.t = 0;
            u401.t = u399 * u394;
            if ((u421.mouse.down.right or u421.controller.down.l2) and t_currentgun_213) then
               local t_type_214 = t_currentgun_213.type;
               if (t_type_214 ~= "KNIFE") then
                  local t_type_215 = t_currentgun_213.type;
                  if (t_type_215 ~= "Grenade") then
                     t_currentgun_213:setaim(true);
                  end
               end
            end
         end
         return;
      end
      if (u389) then
         u389 = false;
         u418.play("slideEnd", 0.15);
      end
      f_setmovementmode(nil, "stand");
      u391 = true;
      u419:send("sprint", u391);
      if (t_currentgun_213) then
         t_currentgun_213.auto = false;
         if (t_currentgun_213 and t_currentgun_213.isaiming()) then
            local t_type_216 = t_currentgun_213.type;
            if (t_type_216 ~= "KNIFE") then
               t_currentgun_213:setaim(false);
            end
         end
      end
      u399 = 1;
      if (not (u390 or u392)) then
         u420.t = 1;
      end
      u401.t = (1.5 * u399) * u394;
   end;
   v5.setsprint = f_setsprint;
   local u422 = v5;
   local u423 = v41;
   local u424 = v1422;
   local u425 = v1366;
   local u426 = v1355;
   local u427 = v1364;
   local u428 = t_Debris_201;
   local f_parkour;
   f_parkour = function()
      --[[
         Name: parkour
         Upvalues: 
            1 => u388
            2 => u390
            3 => u422
            4 => u423
            5 => u424
            6 => u425
            7 => u426
            8 => u386
            9 => u427
            10 => u428
   
      --]]
      if ((u388 and (not u390)) and (not u422.grenadehold)) then
         u388:playanimation("parkour");
      end
      u423.play("parkour", 0.25);
      u424.MaxForce = u425;
      local v1439 = u426("BodyPosition");
      v1439.Name = "\n";
      v1439.position = (u386.Position + ((u386.CFrame.lookVector.unit * u422.speed) * 1.5)) + u427(0, 10, 0);
      v1439.maxForce = u427(500000, 500000, 500000);
      v1439.P = 4000;
      v1439.Parent = u386;
      u428:AddItem(v1439, 0.5);
   end;
   local u429 = t_Debris_201;
   local f_drawparkourray;
   f_drawparkourray = function(p265, p266, p267, p268)
      --[[
         Name: drawparkourray
         Upvalues: 
            1 => u429
   
      --]]
      local v1440 = false;
      local v1441 = Instance.new("Part");
      local v1442;
      if (p266) then
         v1442 = BrickColor.new("Bright red");
         if (not v1442) then
            v1440 = true;
         end
      else
         v1440 = true;
      end
      if (v1440) then
         v1442 = p268;
         if (not v1442) then
            v1442 = BrickColor.new("Bright green");
         end
      end
      v1441.BrickColor = v1442;
      v1441.FormFactor = "Custom";
      v1441.Material = "Neon";
      local v1443;
      if (p266) then
         v1443 = 0.5;
      else
         v1443 = 0.9;
      end
      v1441.Transparency = v1443;
      v1441.Anchored = true;
      v1441.Locked = true;
      v1441.CanCollide = false;
      v1441.Parent = workspace;
      local v1444 = (p265 - p267).Magnitude;
      v1441.Size = Vector3.new(0.05, 0.05, v1444);
      v1441.CFrame = CFrame.new(p265, p267) * CFrame.new(0, 0, (-v1444) / 2);
      u429:AddItem(v1441, 5);
   end;
   local v1445 = {};
   local v1446 = {};
   v1446.lower = 1.8;
   v1446.upper = 4;
   v1446.width = 1.5;
   v1446.xrays = 5;
   v1446.yrays = 8;
   v1446.dist = 10;
   v1446.sprintdist = 12;
   v1446.color = BrickColor.new("Bright blue");
   v1445.mid = v1446;
   local v1447 = {};
   v1447.lower = 5;
   v1447.upper = 6;
   v1447.width = 1;
   v1447.xrays = 5;
   v1447.yrays = 7;
   v1447.dist = 12;
   v1447.sprintdist = 14;
   v1447.color = BrickColor.new("Bright green");
   v1445.upper = v1447;
   local u430 = v1358;
   local u431 = v1445;
   local u432 = v1364;
   local u433 = v1367;
   local u434 = v12;
   local f_parkourdetection;
   f_parkourdetection = function()
      --[[
         Name: parkourdetection
         Upvalues: 
            1 => u386
            2 => u430
            3 => u431
            4 => u432
            5 => u433
            6 => u391
            7 => u434
   
      --]]
      local v1448 = u386.CFrame * u430(0, -3, 0);
      local v1449 = false;
      local v1450 = false;
      local t_lookVector_217 = u386.CFrame.lookVector;
      local v1451 = {};
      v1451.mid = {};
      v1451.upper = {};
      local v1452 = {};
      local g_next_218 = next;
      local v1453 = u431;
      local v1454 = nil;
      while true do
         local v1455, v1456 = g_next_218(v1453, v1454);
         local v1457 = v1455;
         local v1458 = v1456;
         if (v1455) then
            v1454 = v1457;
            local v1459 = 0;
            local v1460 = v1458.xrays - 1;
            local v1461 = v1460;
            local v1462 = v1459;
            if (not (v1460 <= v1462)) then
               while true do
                  local v1463 = 0;
                  local v1464 = v1458.yrays - 1;
                  local v1465 = v1464;
                  local v1466 = v1463;
                  if (not (v1464 <= v1466)) then
                     while true do
                        local v1467 = false;
                        local v1468 = ((v1459 / (v1458.xrays - 1)) - 0.5) * v1458.width;
                        local v1469 = v1468;
                        local v1470 = v1448 * u432(v1468, ((v1463 / (v1458.yrays - 1)) * (v1458.upper - v1458.lower)) + v1458.lower, 0);
                        local v1471 = v1470;
                        local v1472 = u433;
                        local v1473 = v1470;
                        local v1474;
                        if (u391) then
                           v1474 = v1458.sprintdist;
                           if (not v1474) then
                              v1467 = true;
                           end
                        else
                           v1467 = true;
                        end
                        if (v1467) then
                           v1474 = v1458.dist;
                        end
                        local v1475, v1476 = workspace:FindPartOnRayWithWhitelist(v1472(v1473, t_lookVector_217 * v1474), u434.raycastwhitelist);
                        local v1477 = v1476;
                        if (v1475 and v1475.CanCollide) then
                           local v1478 = (v1471 - v1477).Magnitude;
                           local t_Magnitude_219 = v1478;
                           v1451[v1457][(#v1451[v1457]) + 1] = v1478;
                           if (v1457 == "mid") then
                              v1449 = true;
                              if (v1469 == 0) then
                                 v1452[(#v1452) + 1] = t_Magnitude_219;
                              end
                           else
                              if (v1457 == "upper") then
                                 v1450 = true;
                              end
                           end
                        end
                        local v1479 = v1463 + 1;
                        v1463 = v1479;
                        local v1480 = v1465;
                        if (v1480 < v1479) then
                           break;
                        end
                     end
                  end
                  local v1481 = v1459 + 1;
                  v1459 = v1481;
                  local v1482 = v1461;
                  if (v1482 < v1481) then
                     break;
                  end
               end
            end
         else
            break;
         end
      end
      if (v1449) then
         local v1483 = {};
         local v1484 = 2;
         local v1485 = #v1452;
         local v1486 = v1485;
         local v1487 = v1484;
         if (not (v1485 <= v1487)) then
            while true do
               v1483[(#v1483) + 1] = v1452[v1484] - v1452[v1484 - 1];
               local v1488 = v1484 + 1;
               v1484 = v1488;
               local v1489 = v1486;
               if (v1489 < v1488) then
                  break;
               end
            end
         end
         local v1490 = nil;
         local v1491 = 0;
         local v1492 = 1;
         local v1493 = #v1483;
         local v1494 = v1493;
         local v1495 = v1492;
         if (not (v1493 <= v1495)) then
            while true do
               if (v1491 == 0) then
                  v1490 = v1483[v1492];
                  v1491 = 1;
               else
                  if (math.abs(v1483[v1492] - v1490) < 0.01) then
                     v1491 = v1491 + 1;
                  else
                     v1491 = v1491 - 1;
                  end
               end
               local v1496 = v1492 + 1;
               v1492 = v1496;
               local v1497 = v1494;
               if (v1497 < v1496) then
                  break;
               end
            end
         end
         local v1498 = 0;
         local v1499 = 1;
         local v1500 = #v1483;
         local v1501 = v1500;
         local v1502 = v1499;
         if (not (v1500 <= v1502)) then
            while true do
               if (math.abs(v1483[v1499] - v1490) < 0.01) then
                  v1498 = v1498 + 1;
               end
               local v1503 = v1499 + 1;
               v1499 = v1503;
               local v1504 = v1501;
               if (v1504 < v1503) then
                  break;
               end
            end
         end
         if (((((#v1483) / 2) < v1498) and (not (v1490 == 0))) and (math.abs(((u431.mid.upper - u431.mid.lower) / u431.mid.yrays) / v1490) < 2)) then
            return false;
         end
         local v1505 = {};
         v1505.mid = 100;
         v1505.upper = 100;
         local v1506 = {};
         v1506.mid = 0;
         v1506.upper = 0;
         local g_next_220 = next;
         local v1507 = nil;
         while true do
            local v1508, v1509 = g_next_220(v1451, v1507);
            local v1510 = v1508;
            local v1511 = v1509;
            if (v1508) then
               v1507 = v1510;
               local v1512 = 1;
               local v1513 = #v1511;
               local v1514 = v1513;
               local v1515 = v1512;
               if (not (v1513 <= v1515)) then
                  while true do
                     local v1516 = v1511[v1512];
                     local v1517 = v1516;
                     local v1518 = v1505[v1510];
                     if (v1516 < v1518) then
                        v1505[v1510] = v1517;
                     end
                     if (v1506[v1510] < v1517) then
                        v1506[v1510] = v1517;
                     end
                     local v1519 = v1512 + 1;
                     v1512 = v1519;
                     local v1520 = v1514;
                     if (v1520 < v1519) then
                        break;
                     end
                  end
               end
            else
               break;
            end
         end
         local v1521 = math.abs((((v1506.upper + v1505.upper) - v1506.mid) - v1505.mid) / 2);
         if (not (v1450 and (not (v1450 and (v1521 > 4))))) then
            return true;
         end
      end
   end;
   local u435 = v1374;
   local u436 = v13;
   local f_setmovementmode = f_setmovementmode;
   local u437 = v5;
   local f_parkourdetection = f_parkourdetection;
   local f_parkour = f_parkour;
   local f_jump;
   f_jump = function(p269, p270)
      --[[
         Name: jump
         Upvalues: 
            1 => u395
            2 => u435
            3 => u436
            4 => u386
            5 => u403
            6 => f_setmovementmode
            7 => u388
            8 => u437
            9 => f_parkourdetection
            10 => f_parkour
   
      --]]
      if (u395.FloorMaterial == u435) then
         return;
      end
      if (u436.currentgun.knife) then
         p270 = p270 * 1.15;
      end
      local v1522 = false;
      local v1523 = u386.CFrame;
      local t_y_221 = u386.Velocity.y;
      local v1524;
      if (p270) then
         v1524 = ((2 * game.Workspace.Gravity) * p270) ^ 0.5;
         if (not v1524) then
            v1522 = true;
         end
      else
         v1522 = true;
      end
      if (v1522) then
         v1524 = 40;
      end
      local v1525;
      if (t_y_221 < 0) then
         v1525 = v1524;
      else
         v1525 = ((t_y_221 * t_y_221) + (v1524 * v1524)) ^ 0.5;
      end
      local v1526 = u403;
      if (v1526 ~= "prone") then
         local v1527 = u403;
         if (v1527 ~= "crouch") then
            if (u388 and (not u388.isaiming())) then
               local t_speed_222 = u437.speed;
               if ((t_speed_222 > 5) and f_parkourdetection()) then
                  f_parkour();
               else
                  u395.JumpPower = v1525;
                  u395.Jump = true;
               end
               return true;
            end
            u395.JumpPower = v1525;
            u395.Jump = true;
            return true;
         end
      end
      f_setmovementmode(nil, "stand");
   end;
   v5.jump = f_jump;
   local u438 = false;
   local u439 = nil;
   local u440 = nil;
   local u441 = nil;
   local u442 = nil;
   local u443 = nil;
   local u444 = nil;
   v5.grenadehold = false;
   local u445 = v41;
   local f_bfgsounds;
   f_bfgsounds = function()
      --[[
         Name: bfgsounds
         Upvalues: 
            1 => u445
   
      --]]
      u445.play("1PsniperBass", 0.75);
      u445.play("1PsniperEcho", 1);
   end;
   local u446 = v5;
   local u447 = v1351;
   local u448 = v1364;
   local u449 = v1352;
   local u450 = v1353;
   local u451 = v1358;
   local u452 = v23;
   local f_gunbob;
   f_gunbob = function(p271, p272)
      --[[
         Name: gunbob
         Upvalues: 
            1 => u446
            2 => u447
            3 => u394
            4 => u448
            5 => u449
            6 => u450
            7 => u451
            8 => u452
   
      --]]
      local v1528 = p271 or 1;
      local v1529 = p272 or 1;
      local v1530 = u446.slidespring.p;
      local v1531 = ((u446.distance * u447) * 3) / 4;
      local v1532 = u446.speed;
      local v1533 = -u446.velocity;
      local v1534 = v1532 * (1 - (v1530 * 0.9));
      local v1535 = v1534;
      local v1536 = u394;
      if (v1534 < v1536) then
         return u451(((v1529 * u450((v1531 / 8) - 1)) * v1535) / 196, (((1.25 * v1528) * u449(v1531 / 4)) * v1535) / 512, 0) * u452.fromaxisangle(((u448(((v1529 * u449((v1531 / 4) - 1)) / 256) + ((v1529 * (u449(v1531 / 64) - ((v1529 * v1533.z) / 4))) / 512), ((v1529 * u450(v1531 / 128)) / 128) - ((v1529 * u450(v1531 / 8)) / 256), ((v1529 * u449(v1531 / 8)) / 128) + ((v1529 * v1533.x) / 1024)) * v1535) / 20) * u447);
      end
      return u451(((v1529 * u450((v1531 / 8) - 1)) * ((5 * v1535) - 56)) / 196, (((1.25 * v1528) * u449(v1531 / 4)) * v1535) / 512, 0) * u452.fromaxisangle((u448((((((v1529 * u449((v1531 / 4) - 1)) / 256) + ((v1529 * (u449(v1531 / 64) - ((v1529 * v1533.z) / 4))) / 512)) * v1535) / 20) * u447, (((((v1529 * u450(v1531 / 128)) / 128) - ((v1529 * u450(v1531 / 8)) / 256)) * v1535) / 20) * u447, (((((v1529 * u449(v1531 / 8)) / 128) * ((5 * v1535) - 56)) / 20) * u447) + ((v1529 * v1533.x) / 1024))));
   end;
   local u453 = v1358;
   local u454 = v1353;
   local u455 = v1352;
   local f_gunsway;
   f_gunsway = function(p273)
      --[[
         Name: gunsway
         Upvalues: 
            1 => u453
            2 => u454
            3 => u455
   
      --]]
      local v1537 = os.clock() * 6;
      local v1538 = 2 * (1.1 - p273);
      return u453((u454(v1537 / 8) * v1538) / 128, ((-u455(v1537 / 4)) * v1538) / 128, (u455(v1537 / 16) * v1538) / 64);
   end;
   local u456 = t_FindFirstChild_199;
   local u457 = t_AttachmentModels_207;
   local u458 = t_GetChildren_200;
   local u459 = t_toObjectSpace_203;
   local u460 = v1355;
   local f_weldattachment;
   f_weldattachment = function(p274, p275, p276, p277, p278, p279, p280, p281, p282)
      --[[
         Name: weldattachment
         Upvalues: 
            1 => u456
            2 => u457
            3 => u458
            4 => u459
            5 => u460
   
      --]]
      local v1539 = false;
      local v1540;
      if (p279.altmodel) then
         v1540 = u456(u457, p279.altmodel);
         if (not v1540) then
            v1539 = true;
         end
      else
         v1539 = true;
      end
      if (v1539) then
         v1540 = u456(u457, p276);
      end
      local v1541 = p279.copy or 0;
      local v1542 = nil;
      if (v1540) then
         local v1543 = 0;
         local v1544 = v1541;
         local v1545 = v1544;
         local v1546 = v1543;
         if (not (v1544 <= v1546)) then
            while true do
               local v1547 = v1540:Clone();
               local v1548 = v1547;
               local v1549 = v1547.Node;
               local t_Node_223 = v1549;
               local v1550 = {};
               local t_CFrame_224 = v1549.CFrame;
               local v1551 = u458(v1547);
               local v1552 = v1551;
               local v1553 = 1;
               local v1554 = #v1551;
               local v1555 = v1554;
               local v1556 = v1553;
               if (not (v1554 <= v1556)) then
                  while true do
                     local v1557 = v1552[v1553];
                     local v1558 = v1557;
                     if (v1557:IsA("BasePart")) then
                        v1550[v1558] = u459(t_CFrame_224, v1558.CFrame);
                        v1558.CastShadow = false;
                        v1558.Massless = true;
                     end
                     local v1559 = v1553 + 1;
                     v1553 = v1559;
                     local v1560 = v1555;
                     if (v1560 < v1559) then
                        break;
                     end
                  end
               end
               local v1561 = false;
               local v1562;
               if (v1543 == 0) then
                  v1562 = p277.CFrame;
                  if (not v1562) then
                     v1561 = true;
                  end
               else
                  v1561 = true;
               end
               if (v1561) then
                  v1562 = p282[p279.copynodes[v1543]].CFrame;
               end
               t_Node_223.CFrame = v1562;
               if (p275 == "Optics") then
                  local v1563 = p274:GetChildren();
                  local v1564 = v1563;
                  local v1565 = 1;
                  local v1566 = #v1563;
                  local v1567 = v1566;
                  local v1568 = v1565;
                  if (not (v1566 <= v1568)) then
                     while true do
                        local v1569 = false;
                        local t_Name_234 = v1564[v1565].Name;
                        if (t_Name_234 == "Iron") then
                           v1569 = true;
                        else
                           local t_Name_235 = v1564[v1565].Name;
                           if (t_Name_235 == "IronGlow") then
                              v1569 = true;
                           else
                              local t_Name_236 = v1564[v1565].Name;
                              if ((t_Name_236 == "SightMark") and (not u456(v1564[v1565], "Stay"))) then
                                 v1569 = true;
                              end
                           end
                        end
                        if (v1569) then
                           v1564[v1565]:Destroy();
                        end
                        local v1570 = v1565 + 1;
                        v1565 = v1570;
                        local v1571 = v1567;
                        if (v1571 < v1570) then
                           break;
                        end
                     end
                  end
               else
                  if (p275 == "Underbarrel") then
                     local v1572 = p274:GetChildren();
                     local v1573 = v1572;
                     local v1574 = 1;
                     local v1575 = #v1572;
                     local v1576 = v1575;
                     local v1577 = v1574;
                     if (not (v1575 <= v1577)) then
                        while true do
                           local t_Name_233 = v1573[v1574].Name;
                           if (t_Name_233 == "Grip") then
                              local v1578 = u456(v1573[v1574], "Slot1");
                              if (not v1578) then
                                 v1578 = u456(v1573[v1574], "Slot2");
                              end
                              v1542 = v1578;
                              v1573[v1574]:Destroy();
                           end
                           local v1579 = v1574 + 1;
                           v1574 = v1579;
                           local v1580 = v1576;
                           if (v1580 < v1579) then
                              break;
                           end
                        end
                     end
                  else
                     if (p275 == "Barrel") then
                        local v1581 = p274:GetChildren();
                        local v1582 = v1581;
                        local v1583 = 1;
                        local v1584 = #v1581;
                        local v1585 = v1584;
                        local v1586 = v1583;
                        if (not (v1584 <= v1586)) then
                           while true do
                              local t_Name_232 = v1582[v1583].Name;
                              if (t_Name_232 == "Barrel") then
                                 local v1587 = u456(v1582[v1583], "Slot1");
                                 if (not v1587) then
                                    v1587 = u456(v1582[v1583], "Slot2");
                                 end
                                 v1542 = v1587;
                                 v1582[v1583]:Destroy();
                              end
                              local v1588 = v1583 + 1;
                              v1583 = v1588;
                              local v1589 = v1585;
                              if (v1589 < v1588) then
                                 break;
                              end
                           end
                        end
                     end
                  end
               end
               if (p279.replacemag) then
                  local v1590 = p274:GetChildren();
                  local v1591 = v1590;
                  local v1592 = 1;
                  local v1593 = #v1590;
                  local v1594 = v1593;
                  local v1595 = v1592;
                  if (not (v1593 <= v1595)) then
                     while true do
                        local v1596 = false;
                        local v1597 = false;
                        if (v1543 == 0) then
                           local t_Name_231 = v1591[v1592].Name;
                           if (t_Name_231 == "Mag") then
                              v1597 = true;
                           else
                              v1596 = true;
                           end
                        else
                           v1596 = true;
                        end
                        if (v1596) then
                           if (v1543 > 0) then
                              local v1598 = v1591[v1592].Name;
                              local v1599 = "Mag" .. (v1543 + 1);
                              if (v1598 == v1599) then
                                 v1597 = true;
                              end
                           end
                        end
                        if (v1597) then
                           v1591[v1592]:Destroy();
                        end
                        local v1600 = v1592 + 1;
                        v1592 = v1600;
                        local v1601 = v1594;
                        if (v1601 < v1600) then
                           break;
                        end
                     end
                  end
               end
               if (p279.replacepart) then
                  local v1602 = p274:GetChildren();
                  local v1603 = v1602;
                  local v1604 = 1;
                  local v1605 = #v1602;
                  local v1606 = v1605;
                  local v1607 = v1604;
                  if (not (v1605 <= v1607)) then
                     while true do
                        local v1608 = v1603[v1604].Name;
                        local t_replacepart_230 = p279.replacepart;
                        if (v1608 == t_replacepart_230) then
                           v1603[v1604]:Destroy();
                        end
                        local v1609 = v1604 + 1;
                        v1604 = v1609;
                        local v1610 = v1606;
                        if (v1610 < v1609) then
                           break;
                        end
                     end
                  end
               end
               if ((p280 and p280[p276]) and p280[p276].settings) then
                  local g_next_227 = next;
                  local t_settings_228 = p280[p276].settings;
                  local v1611 = nil;
                  while true do
                     local v1612, v1613 = g_next_227(t_settings_228, v1611);
                     local v1614 = v1612;
                     local v1615 = v1613;
                     if (v1612) then
                        v1611 = v1614;
                        if (v1614 == "sightcolor") then
                           local v1616 = u456(v1548, "SightMark");
                           local v1617 = v1616;
                           if (v1616 and u456(v1616, "SurfaceGui")) then
                              local v1618 = v1617.SurfaceGui;
                              local t_SurfaceGui_229 = v1618;
                              if (u456(v1618, "Border") and u456(v1618.Border, "Scope")) then
                                 t_SurfaceGui_229.Border.Scope.ImageColor3 = Color3.new(v1615.r / 255, v1615.g / 255, v1615.b / 255);
                              end
                           end
                        end
                     else
                        break;
                     end
                  end
               end
               local v1619 = false;
               local v1620 = 1;
               local v1621 = #v1552;
               local v1622 = v1621;
               local v1623 = v1620;
               if (v1621 <= v1623) then
                  v1619 = true;
               else
                  while true do
                     local v1624 = false;
                     local v1625 = v1552[v1620];
                     local v1626 = v1625;
                     if (v1625:IsA("BasePart")) then
                        local v1627 = nil;
                        local v1628 = nil;
                        if (v1626 ~= t_Node_223) then
                           v1628 = u459(p278.CFrame, t_Node_223.CFrame);
                           v1627 = u460("Weld");
                           v1627.Part0 = p278;
                           v1627.Part1 = v1626;
                           v1627.C0 = v1628 * v1550[v1626];
                           v1627.Parent = p278;
                           v1626.CFrame = p278.CFrame * v1627.C0;
                        end
                        if (v1542 and v1626:IsA("UnionOperation")) then
                           (v1542:Clone()).Parent = v1626;
                        end
                        if (p279.replacemag) then
                           local t_Name_226 = v1626.Name;
                           if (t_Name_226 == "AttMag") then
                              local v1629;
                              if (v1543 == 0) then
                                 v1629 = "Mag";
                              else
                                 v1629 = false;
                                 if (v1543 > 0) then
                                    v1629 = "Mag" .. (v1543 + 1);
                                 end
                              end
                              v1626.Name = v1629;
                              local v1630 = {};
                              v1630.part = v1626;
                              v1630.weld = v1627;
                              v1630.basec0 = v1628 * v1550[v1626];
                              v1630.basetransparency = v1626.Transparency;
                              p281[v1629] = v1630;
                           end
                        end
                        if (p279.replacepart) then
                           local t_Name_225 = v1626.Name;
                           if (t_Name_225 == "Part") then
                              local v1631 = p279.replacepart;
                              v1626.Name = v1631;
                              local v1632 = {};
                              v1632.part = v1626;
                              v1632.weld = v1627;
                              v1632.basec0 = v1628 * v1550[v1626];
                              v1632.basetransparency = v1626.Transparency;
                              p281[v1631] = v1632;
                           end
                        end
                        v1626.Anchored = false;
                        v1626.CanCollide = false;
                        v1626.Parent = p274;
                        v1624 = true;
                     else
                        v1624 = true;
                     end
                     if (v1624) then
                        local v1633 = v1620 + 1;
                        v1620 = v1633;
                        local v1634 = v1622;
                        if (v1634 < v1633) then
                           break;
                        end
                     end
                  end
                  v1619 = true;
               end
               if (v1619) then
                  t_Node_223:Destroy();
                  v1548:Destroy();
                  local v1635 = v1543 + 1;
                  v1543 = v1635;
                  local v1636 = v1545;
                  if (v1636 < v1635) then
                     break;
                  end
               end
            end
         end
      end
      return v1542;
   end;
   local u461 = t_FindFirstChild_199;
   local u462 = v35;
   local u463 = u204;
   local f_texturemodel;
   f_texturemodel = function(p283, p284)
      --[[
         Name: texturemodel
         Upvalues: 
            1 => u461
            2 => u462
            3 => u463
   
      --]]
      if (p283) then
         local v1637 = BrickColor.new;
         local g_next_237 = next;
         local v1638, v1639 = p284:GetChildren();
         local v1640 = v1638;
         local v1641 = v1639;
         while true do
            local v1642, v1643 = g_next_237(v1640, v1641);
            local v1644 = v1642;
            local v1645 = v1643;
            if (v1642) then
               v1641 = v1644;
               if ((u461(v1645, "Mesh") or v1645:IsA("UnionOperation")) or v1645:IsA("MeshPart")) then
                  local v1646 = u461(v1645, "Slot1");
                  if (not v1646) then
                     v1646 = u461(v1645, "Slot2");
                  end
                  if (v1646 and v1646.Name) then
                     local g_next_238 = next;
                     local v1647, v1648 = v1645:GetChildren();
                     local v1649 = v1647;
                     local v1650 = v1648;
                     while true do
                        local v1651, v1652 = g_next_238(v1649, v1650);
                        local v1653 = v1651;
                        local v1654 = v1652;
                        if (v1651) then
                           v1650 = v1653;
                           if (v1654:IsA("Texture")) then
                              v1654:Destroy();
                           end
                        else
                           break;
                        end
                     end
                     local v1655 = p283[v1646.Name];
                     local v1656 = v1655;
                     if (v1655) then
                        local t_Name_239 = v1656.Name;
                        if (t_Name_239 ~= "") then
                           if (not u462.disable1pcamoskins) then
                              local v1657 = Instance.new("Texture");
                              local v1658 = v1657;
                              v1657.Name = v1646.Name;
                              v1657.Texture = "rbxassetid://" .. v1656.TextureProperties.TextureId;
                              local t_Transparency_241 = v1645.Transparency;
                              local v1659;
                              if (t_Transparency_241 == 1) then
                                 v1659 = 1;
                              else
                                 v1659 = v1656.TextureProperties.Transparency;
                                 if (not v1659) then
                                    v1659 = 0;
                                 end
                              end
                              v1658.Transparency = v1659;
                              v1658.StudsPerTileU = v1656.TextureProperties.StudsPerTileU or 1;
                              v1658.StudsPerTileV = v1656.TextureProperties.StudsPerTileV or 1;
                              v1658.OffsetStudsU = v1656.TextureProperties.OffsetStudsU or 0;
                              v1658.OffsetStudsV = v1656.TextureProperties.OffsetStudsV or 0;
                              if (v1656.TextureProperties.Color) then
                                 local v1660 = v1656.TextureProperties.Color;
                                 v1658.Color3 = Color3.new(v1660.r / 255, v1660.g / 255, v1660.b / 255);
                              end
                              local v1661 = 0;
                              local v1662;
                              if (v1645:IsA("MeshPart") or v1645:IsA("UnionOperation")) then
                                 v1662 = 5;
                              else
                                 v1662 = 0;
                              end
                              local v1663 = v1661;
                              local v1664 = v1662;
                              if (not (v1664 <= v1663)) then
                                 while true do
                                    local v1665 = v1658:Clone();
                                    v1665.Face = v1661;
                                    v1665.Parent = v1645;
                                    local v1666 = v1661 + 1;
                                    v1661 = v1666;
                                    local v1667 = v1662;
                                    if (v1667 < v1666) then
                                       break;
                                    end
                                 end
                              end
                              v1658:Destroy();
                           end
                           if (not v1656.BrickProperties.DefaultColor) then
                              if (v1645:IsA("UnionOperation")) then
                                 v1645.UsePartColor = true;
                              end
                              local v1668 = v1656.BrickProperties.Color;
                              local t_Color_240 = v1668;
                              if (v1668) then
                                 v1645.Color = Color3.new(t_Color_240.r / 255, t_Color_240.g / 255, t_Color_240.b / 255);
                              else
                                 if (v1656.BrickProperties.BrickColor) then
                                    v1645.BrickColor = v1637(v1656.BrickProperties.BrickColor);
                                 end
                              end
                           end
                           if (v1656.BrickProperties.Material) then
                              v1645.Material = v1656.BrickProperties.Material;
                           end
                           if (v1656.BrickProperties.Reflectance) then
                              v1645.Reflectance = v1656.BrickProperties.Reflectance;
                           end
                        end
                     end
                  end
               else
                  if (v1645:IsA("Model")) then
                     u463(p283, v1645);
                  end
               end
            else
               break;
            end
         end
      end
   end;
   local u464 = t_FindFirstChild_199;
   local u465 = t_toObjectSpace_203;
   local u466 = v1355;
   local u467 = t_AttachmentModels_207;
   local f_weldattachment = f_weldattachment;
   local f_texturemodel = f_texturemodel;
   local f_weldmodel;
   f_weldmodel = function(p285, p286, p287, p288, p289, p290, p291)
      --[[
         Name: weldmodel
         Upvalues: 
            1 => u464
            2 => u465
            3 => u466
            4 => u467
            5 => f_weldattachment
            6 => f_texturemodel
   
      --]]
      local v1669 = {};
      local v1670 = p285:GetChildren();
      local t_CFrame_242 = p286.CFrame;
      local v1671 = u464(p285, "MenuNodes");
      if (not p291) then
         local v1672 = 1;
         local v1673 = #v1670;
         local v1674 = v1673;
         local v1675 = v1672;
         if (not (v1673 <= v1675)) then
            while true do
               local v1676 = v1670[v1672];
               local v1677 = v1676;
               if (v1676:IsA("BasePart")) then
                  v1677.Massless = true;
                  v1677.CastShadow = false;
               end
               if ((not (v1677 == p286)) and v1677:IsA("BasePart")) then
                  local v1678 = v1677.Name;
                  local t_Name_254 = v1678;
                  if ((p288 and p288.removeparts) and p288.removeparts[v1678]) then
                     v1677:Destroy();
                  else
                     if ((p288 and p288.transparencymod) and p288.transparencymod[t_Name_254]) then
                        v1677.Transparency = p288.transparencymod[t_Name_254];
                     end
                     if (((p288 and p288.weldexception) and p288.weldexception[t_Name_254]) and u464(p285, p288.weldexception[t_Name_254])) then
                        local v1679 = p285[p288.weldexception[t_Name_254]];
                        local v1680 = u465(v1679.CFrame, v1677.CFrame);
                        local v1681 = u466("Weld");
                        v1681.Part0 = v1679;
                        v1681.Part1 = v1677;
                        v1681.C0 = v1680;
                        v1681.Parent = p286;
                        v1677.CFrame = t_CFrame_242 * v1680;
                        local v1682 = {};
                        v1682.part = v1677;
                        v1682.weld = v1681;
                        v1682.basec0 = v1680;
                        v1682.basetransparency = v1677.Transparency;
                        v1669[t_Name_254] = v1682;
                     else
                        local v1683 = u465(t_CFrame_242, v1677.CFrame);
                        local v1684 = u466("Weld");
                        v1684.Part0 = p286;
                        v1684.Part1 = v1677;
                        v1684.C0 = v1683;
                        v1684.Parent = p286;
                        v1677.CFrame = t_CFrame_242 * v1683;
                        local v1685 = {};
                        v1685.part = v1677;
                        v1685.weld = v1684;
                        v1685.basec0 = v1683;
                        v1685.basetransparency = v1677.Transparency;
                        v1669[t_Name_254] = v1685;
                     end
                     v1677.Anchored = false;
                     v1677.CanCollide = false;
                  end
               end
               local v1686 = v1672 + 1;
               v1672 = v1686;
               local v1687 = v1674;
               if (v1687 < v1686) then
                  break;
               end
            end
         end
      end
      if (v1671 and p287) then
         local v1688 = v1671:GetChildren();
         local v1689 = v1688;
         local v1690 = 1;
         local v1691 = #v1688;
         local v1692 = v1691;
         local v1693 = v1690;
         if (not (v1691 <= v1693)) then
            while true do
               local v1694 = v1689[v1690];
               local v1695 = u465(t_CFrame_242, v1694.CFrame);
               local v1696 = u466("Weld");
               v1696.Part0 = p286;
               v1696.Part1 = v1694;
               v1696.C0 = v1695;
               v1696.Parent = p286;
               v1694.Massless = true;
               v1694.CastShadow = false;
               v1694.Anchored = false;
               v1694.CanCollide = false;
               local v1697 = v1690 + 1;
               v1690 = v1697;
               local v1698 = v1692;
               if (v1698 < v1697) then
                  break;
               end
            end
         end
         local g_next_243 = next;
         local v1699 = p287;
         local v1700 = nil;
         while true do
            local v1701, v1702 = g_next_243(v1699, v1700);
            local v1703 = v1701;
            local v1704 = v1702;
            if (v1701) then
               v1700 = v1703;
               if (((not (v1703 == "Name")) and v1704) and (not (v1704 == ""))) then
                  local v1705 = false;
                  local v1706;
                  if (p288.attachments) then
                     v1706 = p288.attachments[v1703][v1704];
                     if (not v1706) then
                        v1705 = true;
                     end
                  else
                     v1705 = true;
                  end
                  if (v1705) then
                     v1706 = {};
                  end
                  local v1707 = v1706.sidemount;
                  if (v1707) then
                     v1707 = u467[v1706.sidemount]:Clone();
                  end
                  local v1708 = false;
                  local v1709;
                  if (v1706.mountweldpart) then
                     v1709 = p285[v1706.mountweldpart];
                     if (not v1709) then
                        v1708 = true;
                     end
                  else
                     v1708 = true;
                  end
                  if (v1708) then
                     v1709 = p286;
                  end
                  local v1710 = v1706.node;
                  if (v1710) then
                     v1710 = v1671[v1706.node];
                  end
                  local v1711 = false;
                  local v1712 = {};
                  if (v1707) then
                     local v1713 = false;
                     local t_Node_250 = v1707.Node;
                     local v1714;
                     if (v1706.mountnode) then
                        v1714 = v1671[v1706.mountnode];
                        if (not v1714) then
                           v1713 = true;
                        end
                     else
                        v1713 = true;
                     end
                     if (v1713) then
                        local v1715 = false;
                        if (v1703 == "Optics") then
                           v1714 = v1671.MountNode;
                           if (not v1714) then
                              v1715 = true;
                           end
                        else
                           v1715 = true;
                        end
                        if (v1715) then
                           v1714 = false;
                           if (v1703 == "Underbarrel") then
                              v1714 = v1671.UnderMountNode;
                           end
                        end
                     end
                     local v1716 = {};
                     local v1717 = v1707:GetChildren();
                     local v1718 = v1717;
                     local t_CFrame_251 = t_Node_250.CFrame;
                     local v1719 = 1;
                     local v1720 = #v1717;
                     local v1721 = v1720;
                     local v1722 = v1719;
                     if (not (v1720 <= v1722)) then
                        while true do
                           if (v1718[v1719]:IsA("BasePart")) then
                              v1716[v1719] = u465(t_CFrame_251, v1718[v1719].CFrame);
                           end
                           local v1723 = v1719 + 1;
                           v1719 = v1723;
                           local v1724 = v1721;
                           if (v1724 < v1723) then
                              break;
                           end
                        end
                     end
                     t_Node_250.CFrame = v1714.CFrame;
                     local v1725 = 1;
                     local v1726 = #v1718;
                     local v1727 = v1726;
                     local v1728 = v1725;
                     if (not (v1726 <= v1728)) then
                        while true do
                           local v1729 = v1718[v1725];
                           local v1730 = v1729;
                           local t_Name_252 = v1729.Name;
                           if (v1729:IsA("BasePart")) then
                              local v1731 = u465(v1709.CFrame, t_Node_250.CFrame);
                              local v1732 = u465(p286.CFrame, v1709.CFrame);
                              if (v1730 ~= t_Node_250) then
                                 local v1733 = u466("Weld");
                                 local v1734;
                                 if (v1706.weldtobase) then
                                    v1733.Part0 = p286;
                                    v1733.Part1 = v1730;
                                    v1733.C0 = (v1732 * v1731) * v1716[v1725];
                                    v1730.CFrame = t_Node_250.CFrame * v1716[v1725];
                                    v1734 = u465(t_CFrame_242, v1730.CFrame);
                                 else
                                    v1733.Part0 = v1709;
                                    v1733.Part1 = v1730;
                                    v1733.C0 = v1731 * v1716[v1725];
                                    v1730.CFrame = t_Node_250.CFrame * v1716[v1725];
                                    v1734 = u465(v1709.CFrame, v1730.CFrame);
                                 end
                                 v1733.Parent = p286;
                                 local v1735 = {};
                                 v1735.part = v1730;
                                 v1735.weld = v1733;
                                 v1735.basec0 = v1734;
                                 v1735.basetransparency = v1730.Transparency;
                                 v1669[t_Name_252] = v1735;
                              end
                              v1730.CastShadow = false;
                              v1730.Massless = true;
                              v1730.Anchored = false;
                              v1730.CanCollide = false;
                              v1730.Parent = p285;
                              v1712[v1730.Name] = v1730;
                              local v1736 = v1730.Name;
                              local v1737 = v1703 .. "Node";
                              if ((v1736 == v1737) and (not v1710)) then
                                 v1710 = v1730;
                              else
                                 local t_Name_253 = v1730.Name;
                                 if (t_Name_253 == "SightMark") then
                                    local v1738 = u466("Model");
                                    v1738.Name = "Stay";
                                    v1738.Parent = v1730;
                                 end
                              end
                           end
                           local v1739 = v1725 + 1;
                           v1725 = v1739;
                           local v1740 = v1727;
                           if (v1740 < v1739) then
                              break;
                           end
                        end
                     end
                     t_Node_250.Parent = v1671;
                     v1707:Destroy();
                     v1711 = true;
                  else
                     local v1741 = false;
                     local v1742;
                     if (v1706.node) then
                        v1742 = v1671[v1706.node];
                        if (not v1742) then
                           v1741 = true;
                        end
                     else
                        v1741 = true;
                     end
                     if (v1741) then
                        v1742 = v1671[v1703 .. "Node"];
                     end
                     v1710 = v1742;
                     v1711 = true;
                  end
                  if (v1711) then
                     local v1743 = false;
                     if (v1706.auxmodels) then
                        local v1744 = {};
                        local g_next_244 = next;
                        local t_auxmodels_245 = v1706.auxmodels;
                        local v1745 = nil;
                        while true do
                           local v1746, v1747 = g_next_244(t_auxmodels_245, v1745);
                           local v1748 = v1746;
                           local v1749 = v1747;
                           if (v1746) then
                              v1745 = v1748;
                              local v1750 = v1749.Name;
                              if (not v1750) then
                                 v1750 = v1704 .. (" " .. v1749.PostName);
                              end
                              local v1751 = u467[v1750]:Clone();
                              local v1752 = v1751;
                              local t_Node_246 = v1751.Node;
                              v1744[v1750] = {};
                              local v1753;
                              if (v1749.sidemount and v1712[v1749.Node]) then
                                 v1753 = v1712[v1749.Node];
                              else
                                 if ((v1749.auxmount and v1744[v1749.auxmount]) and v1744[v1749.auxmount][v1749.Node]) then
                                    v1753 = v1744[v1749.auxmount][v1749.Node];
                                 else
                                    v1753 = v1671[v1749.Node];
                                 end
                              end
                              if (v1749.mainnode) then
                                 v1710 = v1752[v1749.mainnode];
                              end
                              local v1754 = {};
                              local v1755 = v1752:GetChildren();
                              local v1756 = v1755;
                              local t_CFrame_247 = t_Node_246.CFrame;
                              local v1757 = 1;
                              local v1758 = #v1755;
                              local v1759 = v1758;
                              local v1760 = v1757;
                              if (not (v1758 <= v1760)) then
                                 while true do
                                    if (v1756[v1757]:IsA("BasePart")) then
                                       v1754[v1757] = u465(t_CFrame_247, v1756[v1757].CFrame);
                                    end
                                    local v1761 = v1757 + 1;
                                    v1757 = v1761;
                                    local v1762 = v1759;
                                    if (v1762 < v1761) then
                                       break;
                                    end
                                 end
                              end
                              t_Node_246.CFrame = v1753.CFrame;
                              local v1763 = 1;
                              local v1764 = #v1756;
                              local v1765 = v1764;
                              local v1766 = v1763;
                              if (not (v1764 <= v1766)) then
                                 while true do
                                    local v1767 = v1756[v1763];
                                    local v1768 = v1767;
                                    local t_Name_248 = v1767.Name;
                                    if (v1767:IsA("BasePart")) then
                                       local v1769 = u465(v1709.CFrame, t_Node_246.CFrame);
                                       local v1770 = u465(p286.CFrame, v1709.CFrame);
                                       if (v1768 ~= t_Node_246) then
                                          local v1771 = u466("Weld");
                                          local v1772;
                                          if (v1749.weldtobase) then
                                             v1771.Part0 = p286;
                                             v1771.Part1 = v1768;
                                             v1771.C0 = (v1770 * v1769) * v1754[v1763];
                                             v1768.CFrame = t_Node_246.CFrame * v1754[v1763];
                                             v1772 = u465(t_CFrame_242, v1768.CFrame);
                                          else
                                             v1771.Part0 = v1709;
                                             v1771.Part1 = v1768;
                                             v1771.C0 = v1769 * v1754[v1763];
                                             v1768.CFrame = t_Node_246.CFrame * v1754[v1763];
                                             v1772 = u465(v1709.CFrame, v1768.CFrame);
                                          end
                                          v1771.Parent = p286;
                                          local v1773 = {};
                                          v1773.part = v1768;
                                          v1773.weld = v1771;
                                          v1773.basec0 = v1772;
                                          v1773.basetransparency = v1768.Transparency;
                                          v1669[t_Name_248] = v1773;
                                       end
                                       v1768.CastShadow = false;
                                       v1768.Massless = true;
                                       v1768.Anchored = false;
                                       v1768.CanCollide = false;
                                       v1768.Parent = p285;
                                       v1744[v1750][v1768.Name] = v1768;
                                       local v1774 = v1768.Name;
                                       local v1775 = v1748 .. "Node";
                                       if ((v1774 == v1775) and (not v1710)) then
                                          v1710 = v1768;
                                       else
                                          local t_Name_249 = v1768.Name;
                                          if (t_Name_249 == "SightMark") then
                                             local v1776 = u466("Model");
                                             v1776.Name = "Stay";
                                             v1776.Parent = v1768;
                                          end
                                       end
                                    end
                                    local v1777 = v1763 + 1;
                                    v1763 = v1777;
                                    local v1778 = v1765;
                                    if (v1778 < v1777) then
                                       break;
                                    end
                                 end
                              end
                              v1752:Destroy();
                           else
                              break;
                           end
                        end
                        v1743 = true;
                     else
                        v1743 = true;
                     end
                     if (v1743) then
                        local v1779 = false;
                        local v1780;
                        if (v1706.weldpart) then
                           v1780 = p285[v1706.weldpart];
                           if (not v1780) then
                              v1779 = true;
                           end
                        else
                           v1779 = true;
                        end
                        if (v1779) then
                           v1780 = p286;
                        end
                        f_weldattachment(p285, v1703, v1704, v1710, v1780, v1706, p290, v1669, v1671);
                     end
                  end
               end
            else
               break;
            end
         end
         v1671:Destroy();
      end
      if (not p291) then
         f_texturemodel(p289, p285);
         v1669.camodata = p289;
         p286.Anchored = false;
         p286.CanCollide = false;
      end
      if (p288) then
         local v1781 = {};
         v1669.gunvars = v1781;
         local v1782 = p288.casetype;
         if (not v1782) then
            v1782 = p288.ammotype;
         end
         v1781.ammotype = v1782;
         v1781.boltlock = p288.boltlock;
      end
      return v1669;
   end;
   local v1783 = game.Clone;
   local v1784 = game.Workspace.CurrentCamera;
   local v1785 = game.FindFirstChild;
   local t_CurrentCamera_255 = v1784;
   local u468 = v1355;
   local f_weldmodel = f_weldmodel;
   local f_loadarms;
   f_loadarms = function(p292, p293, p294, p295, p296)
      --[[
         Name: loadarms
         Upvalues: 
            1 => u441
            2 => u442
            3 => t_CurrentCamera_255
            4 => u443
            5 => u444
            6 => u439
            7 => u468
            8 => u440
            9 => f_weldmodel
            10 => u386
   
      --]]
      if (u441 and u442) then
         u441:Destroy();
         u442:Destroy();
      end
      local v1786 = p293;
      local v1787 = p294;
      u441 = v1786;
      u442 = v1787;
      u441.Parent = t_CurrentCamera_255;
      u442.Parent = t_CurrentCamera_255;
      u443 = u441[p295];
      u444 = u442[p296];
      u439 = u468("Motor6D");
      u440 = u468("Motor6D");
      f_weldmodel(u441, u443);
      f_weldmodel(u442, u444);
      u440.Part0 = u386;
      u440.Part1 = u443;
      u440.Parent = u443;
      u439.Part0 = u386;
      u439.Part1 = u444;
      u439.Parent = u444;
   end;
   v5.loadarms = f_loadarms;
   local u469 = v1414;
   local u470 = v1415;
   local u471 = v1419;
   local u472 = v1379;
   local u473 = v1387;
   local u474 = v1408;
   local u475 = v1366;
   local u476 = v1410;
   local u477 = v1412;
   local u478 = v1417;
   local u479 = v1420;
   local u480 = t_ReplicatedStorage_206;
   local f_reloadsprings;
   f_reloadsprings = function(p297)
      --[[
         Name: reloadsprings
         Upvalues: 
            1 => u469
            2 => u470
            3 => u471
            4 => u472
            5 => u473
            6 => u474
            7 => u475
            8 => u476
            9 => u477
            10 => u478
            11 => u479
            12 => u401
            13 => u394
            14 => u402
            15 => u400
            16 => u480
            17 => u386
   
      --]]
      u469.t = 0;
      u470.t = 0;
      u471.t = 1;
      u471.s = 12;
      u471.d = 0.75;
      u472.t = 0;
      u472.s = 12;
      u472.d = 0.9;
      u473.t = 0;
      u473.d = 0.9;
      u474.t = u475;
      u474.s = 10;
      u474.d = 0.75;
      u476.t = 0;
      u476.s = 16;
      u477.t = u475;
      u477.s = 16;
      u478.t = 0;
      u478.s = 8;
      u479.t = 0;
      u479.s = 50;
      u479.d = 1;
      u401.t = u394;
      u401.s = 8;
      u402.t = 1.5;
      u402.s = 8;
      if (u400) then
         u400:Destroy();
      end
      u400 = u480.Effects.MuzzleLight:Clone();
      u400.Parent = u386;
   end;
   v5.reloadsprings = f_reloadsprings;
   local v1788 = math.random;
   local v1789 = game.FindFirstChild;
   local u481 = v1364;
   local u482 = v1788;
   local f_pickv3;
   f_pickv3 = function(p298, p299)
      --[[
         Name: pickv3
         Upvalues: 
            1 => u481
            2 => u482
   
      --]]
      return p298 + (u481(u482(), u482(), u482()) * (p299 - p298));
   end;
   local u483 = v1420;
   local f_firemuzzlelight;
   f_firemuzzlelight = function(p300)
      --[[
         Name: firemuzzlelight
         Upvalues: 
            1 => u483
   
      --]]
      u483.a = 100;
   end;
   v5.firemuzzlelight = f_firemuzzlelight;
   local u484 = v31;
   local u485 = v1364;
   local f_weldmodel = f_weldmodel;
   local u486 = v1355;
   local u487 = v1360;
   local u488 = v23;
   local u489 = v5;
   local u490 = v7;
   local u491 = v1378;
   local u492 = v1419;
   local t_CurrentCamera_256 = v1784;
   local u493 = v12;
   local u494 = v13;
   local t_FindFirstChild_257 = v1789;
   local u495 = v30;
   local u496 = v1362;
   local u497 = v1366;
   local u498 = v1367;
   local u499 = t_Dot_202;
   local u500 = v18;
   local u501 = v1379;
   local u502 = v32;
   local u503 = v33;
   local u504 = v35;
   local u505 = v1414;
   local u506 = v1358;
   local u507 = v1408;
   local f_gunbob = f_gunbob;
   local f_gunsway = f_gunsway;
   local u508 = v1417;
   local f_loadgrenade;
   f_loadgrenade = function(p301, p302, p303)
      --[[
         Name: loadgrenade
         Upvalues: 
            1 => u484
            2 => f_gunrequire
            3 => t_getGunModel_3
            4 => u485
            5 => f_weldmodel
            6 => u486
            7 => u487
            8 => u386
            9 => u488
            10 => u438
            11 => u489
            12 => u490
            13 => u491
            14 => u492
            15 => t_CurrentCamera_256
            16 => u388
            17 => u392
            18 => u493
            19 => u494
            20 => t_FindFirstChild_257
            21 => u495
            22 => u496
            23 => u497
            24 => u498
            25 => u499
            26 => u500
            27 => u501
            28 => u502
            29 => u391
            30 => u503
            31 => u504
            32 => u505
            33 => u506
            34 => u507
            35 => f_gunbob
            36 => f_gunsway
            37 => u508
            38 => u401
            39 => u440
            40 => u439
   
      --]]
      local v1790 = {};
      local v1791 = u484.new();
      local v1792 = f_gunrequire(p302);
      local v1793 = t_getGunModel_3(p302):Clone();
      local v1794 = v1792.mainpart;
      local v1795 = v1792.mainoffset;
      local v1796 = v1793[v1794];
      local v1797 = v1793[v1792.pin];
      local u509 = false;
      local u510 = false;
      local u511 = false;
      local u512 = false;
      local v1798 = u485(0, -80, 0);
      local u513 = u485();
      local u514 = u485();
      local u515 = 0;
      local u516 = 0;
      local u517 = 0;
      local u518 = false;
      local u519 = u485();
      local u520 = nil;
      local u521 = nil;
      local u522 = nil;
      local v1799 = v1792.fusetime;
      local v1800 = v1792.blastradius;
      local v1801 = v1792.throwspeed;
      local v1802 = v1792.range0;
      local v1803 = v1792.range1;
      local v1804 = v1792.damage0;
      local v1805 = v1792.damage1;
      local v1806 = f_weldmodel(v1793, v1796);
      local v1807 = u486("Motor6D");
      local v1808 = {};
      local v1809 = {};
      v1809.C0 = u487;
      v1808.weld = v1809;
      v1808.basec0 = u487;
      v1806[v1794] = v1808;
      local v1810 = {};
      local v1811 = {};
      v1811.C0 = v1792.larmoffset;
      v1810.weld = v1811;
      v1810.basec0 = v1792.larmoffset;
      v1806.larm = v1810;
      local v1812 = {};
      local v1813 = {};
      v1813.C0 = v1792.rarmoffset;
      v1812.weld = v1813;
      v1812.basec0 = v1792.rarmoffset;
      v1806.rarm = v1812;
      v1807.Part0 = u386;
      v1807.Part1 = v1796;
      v1807.Parent = v1796;
      local v1814 = v1792.equipoffset;
      local v1815 = u488.interpolator(v1792.sprintoffset);
      local v1816 = u488.interpolator(v1792.proneoffset);
      v1790.type = v1792.type;
      v1790.cooking = u511;
      local f_isaiming;
      f_isaiming = function()
         --[[
            Name: isaiming
         --]]
         return false;
      end;
      v1790.isaiming = f_isaiming;
      local u523 = v1792;
      local t_mainpart_258 = v1794;
      local u524 = p303;
      local u525 = v1796;
      local u526 = v1793;
      local f_setequipped;
      f_setequipped = function(p304, p305)
         --[[
            Name: setequipped
            Upvalues: 
               1 => u509
               2 => u438
               3 => u489
               4 => u490
               5 => u523
               6 => t_mainpart_258
               7 => u491
               8 => u524
               9 => u492
               10 => u525
               11 => u526
               12 => t_CurrentCamera_256
               13 => u388
               14 => u392
   
         --]]
         if (not (p305 and (not (u509 and u438)))) then
            if ((not p305) and u509) then
               u492.t = 1;
               u491:clear();
               u491:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u509
                        2 => u526
                        3 => u392
                        4 => u388
   
                  --]]
                  u509 = false;
                  u526.Parent = nil;
                  u392 = false;
                  u388 = nil;
               end);
               u491:delay(0.5);
            end
            return;
         end
         if (not u489.alive) then
            return;
         end
         u489.grenadehold = true;
         u490:setcrosssettings(u523.type, u523.crosssize, u523.crossspeed, u523.crossdamper, t_mainpart_258);
         u490:updatefiremode("KNIFE");
         u490:updateammo("GRENADE");
         u438 = true;
         u491:clear();
         u524:setequipped(false);
         local v1817 = u491;
         local u527 = p304;
         v1817:add(function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u489
                  2 => u523
                  3 => u492
                  4 => u438
                  5 => u509
                  6 => u525
                  7 => u526
                  8 => t_CurrentCamera_256
                  9 => u388
                  10 => u527
   
            --]]
            u489:setbasewalkspeed(u523.walkspeed);
            u492.t = 0;
            u438 = false;
            u509 = true;
            local v1818 = u525:GetChildren();
            local v1819 = v1818;
            local v1820 = 1;
            local v1821 = #v1818;
            local v1822 = v1821;
            local v1823 = v1820;
            if (not (v1821 <= v1823)) then
               while true do
                  if (v1819[v1820]:IsA("Weld")) then
                     local v1824 = false;
                     if (v1819[v1820].Part1) then
                        local v1825 = v1819[v1820].Part1.Parent;
                        local v1826 = u526;
                        if (v1825 ~= v1826) then
                           v1824 = true;
                        end
                     else
                        v1824 = true;
                     end
                     if (v1824) then
                        v1819[v1820]:Destroy();
                     end
                  end
                  local v1827 = v1820 + 1;
                  v1820 = v1827;
                  local v1828 = v1822;
                  if (v1828 < v1827) then
                     break;
                  end
               end
            end
            u526.Parent = t_CurrentCamera_256;
            u388 = u527;
         end);
      end;
      v1790.setequipped = f_setequipped;
      local u528 = nil;
      local u529 = 0;
      local u530 = v1796;
      local u531 = v1807;
      local u532 = v1793;
      local u533 = v1792;
      local t_throwspeed_259 = v1801;
      local u534 = v1798;
      local f_createnade;
      f_createnade = function(p306)
         --[[
            Name: createnade
            Upvalues: 
               1 => u493
               2 => u530
               3 => u494
               4 => u490
               5 => u531
               6 => u522
               7 => t_FindFirstChild_257
               8 => u532
               9 => u495
               10 => u496
               11 => u533
               12 => u513
               13 => u489
               14 => t_throwspeed_259
               15 => u386
               16 => u514
               17 => u517
               18 => u521
               19 => u485
               20 => u520
               21 => u528
               22 => u516
               23 => u497
               24 => u534
               25 => u498
               26 => u519
               27 => u499
               28 => u488
               29 => u518
               30 => u529
               31 => u500
   
         --]]
         if ((not p306) and u493.lock) then
            return;
         end
         if (not (u530.Parent and (not (u494.gammo <= 0)))) then
            return;
         end
         u494.gammo = u494.gammo - 1;
         u490:updateammo("GRENADE");
         local v1829 = tick();
         u531:Destroy();
         u522 = t_FindFirstChild_257(u530, "Indicator");
         if (u522) then
            u522.Friendly.Visible = true;
         end
         local v1830 = false;
         u530.CastShadow = false;
         u530.Massless = true;
         u530.Anchored = true;
         u530.Trail.Enabled = true;
         u530.Ticking:Play();
         u530.Parent = workspace.Ignore.Misc;
         u532.Parent = nil;
         local v1831 = u495.cframe * u496(math.rad(u533.throwangle or 0), 0, 0);
         local v1832;
         if (u489.alive) then
            v1832 = (v1831.lookVector * t_throwspeed_259) + u386.Velocity;
            if (not v1832) then
               v1830 = true;
            end
         else
            v1830 = true;
         end
         if (v1830) then
            v1832 = Vector3.new(math.random(-3, 5), math.random(0, 2), math.random(-3, 5));
         end
         local v1833 = false;
         u513 = v1832;
         local v1834;
         if (u489.deadcf) then
            v1834 = u489.deadcf.p;
            if (not v1834) then
               v1833 = true;
            end
         else
            v1833 = true;
         end
         if (v1833) then
            v1834 = u530.CFrame.p;
         end
         u514 = v1834;
         u517 = v1829;
         u521 = (u495.cframe - u495.cframe.p) * u485(19.539, -5, 0);
         u520 = u530.CFrame - u530.CFrame.p;
         local v1835 = u530.CFrame;
         local v1836 = {};
         v1836.time = v1829;
         v1836.blowuptime = u516 - v1829;
         local v1837 = {};
         local v1838 = {};
         v1838.t0 = 0;
         v1838.p0 = u514;
         v1838.v0 = u513;
         v1838.offset = u497;
         v1838.a = u534;
         v1838.rot0 = v1835 - v1835.p;
         v1838.rotv = u521;
         v1838.glassbreaks = {};
         v1837[1] = v1838;
         v1836.frames = v1837;
         u528 = v1836;
         local v1839 = 1;
         local v1840 = ((u516 - v1829) / 0.01666666666666667) + 1;
         local v1841 = v1840;
         local v1842 = v1839;
         if (not (v1840 <= v1842)) then
            local v1846, v1852, v1854, v1853;
            while true do
               local v1843 = false;
               local v1844 = false;
               local v1845 = (u514 + (0.01666666666666667 * u513)) + (0.0001388888888888889 * u534);
               v1846 = v1845;
               local v1847 = u513 + (0.01666666666666667 * u534);
               local v1848, v1849, v1850 = workspace:FindPartOnRayWithWhitelist(u498(u514, (v1845 - u514) - (0.05 * u519)), u493.raycastwhitelist);
               local v1851 = v1848;
               v1852 = v1849;
               v1853 = v1850;
               v1854 = 0.01666666666666667 * v1839;
               if (v1848) then
                  local t_Name_261 = v1851.Name;
                  if (t_Name_261 == "Window") then
                     v1843 = true;
                  else
                     local t_Name_262 = v1851.Name;
                     if (t_Name_262 == "Col") then
                        v1843 = true;
                     else
                        u520 = u530.CFrame - u530.CFrame.p;
                        u519 = 0.2 * v1853;
                        u521 = v1853:Cross(u513) / 0.2;
                        local v1855 = v1852 - u514;
                        local v1856 = v1855;
                        local v1857 = 1 - (0.001 / v1855.magnitude);
                        local v1858 = v1857;
                        local v1859;
                        if (v1857 < 0) then
                           v1859 = 0;
                        else
                           v1859 = v1858;
                        end
                        u514 = (u514 + (v1859 * v1856)) + (0.05 * v1853);
                        local v1860 = u499(v1853, u513) * v1853;
                        local v1861 = v1860;
                        local v1862 = u513 - v1860;
                        local v1863 = -u499(v1853, u534);
                        local v1864 = v1863;
                        local v1865 = -1.2 * u499(v1853, u513);
                        local v1866;
                        if (v1863 < 0) then
                           v1866 = 0;
                        else
                           v1866 = v1864;
                        end
                        local v1867 = (10 * v1866) * 0.01666666666666667;
                        local v1868;
                        if (v1865 < 0) then
                           v1868 = 0;
                        else
                           v1868 = v1865;
                        end
                        local v1869 = 1 - ((0.08 * (v1867 + v1868)) / v1862.magnitude);
                        local v1870 = v1869;
                        local v1871;
                        if (v1869 < 0) then
                           v1871 = 0;
                        else
                           v1871 = v1870;
                        end
                        u513 = (v1871 * v1862) - (0.2 * v1861);
                        if (u513.magnitude < 1) then
                           break;
                        end
                        local v1872 = false;
                        local v1873 = u528.frames;
                        local t_frames_263 = v1873;
                        local v1874 = (#v1873) + 1;
                        local v1875 = (#v1873) + 1;
                        local v1876 = {};
                        v1876.t0 = v1854 - ((0.01666666666666667 * (v1846 - v1852).magnitude) / (v1846 - u514).magnitude);
                        v1876.p0 = u514;
                        v1876.v0 = u513;
                        local v1877;
                        if (u518) then
                           v1877 = u497;
                           if (not v1877) then
                              v1872 = true;
                           end
                        else
                           v1872 = true;
                        end
                        if (v1872) then
                           v1877 = u534;
                        end
                        v1876.a = v1877;
                        v1876.rot0 = u488.fromaxisangle(v1854 * u521) * u520;
                        v1876.offset = 0.2 * v1853;
                        v1876.rotv = u521;
                        v1876.glassbreaks = {};
                        t_frames_263[v1875] = v1876;
                        u518 = true;
                        v1844 = true;
                     end
                  end
               else
                  v1843 = true;
               end
               if (v1843) then
                  u514 = v1846;
                  u513 = v1847;
                  u518 = false;
                  if (v1851) then
                     local t_Name_260 = v1851.Name;
                     if ((t_Name_260 == "Window") and (u529 < 5)) then
                        u529 = u529 + 1;
                        local v1878 = u528.frames;
                        local v1879 = v1878[#v1878].glassbreaks;
                        local v1880 = (#v1879) + 1;
                        local v1881 = {};
                        v1881.t = v1854;
                        v1881.part = v1851;
                        v1879[v1880] = v1881;
                        v1844 = true;
                     else
                        v1844 = true;
                     end
                  else
                     v1844 = true;
                  end
               end
               if (v1844) then
                  local v1882 = v1839 + 1;
                  v1839 = v1882;
                  local v1883 = v1841;
                  if (v1883 < v1882) then
                     break;
                  end
               end
            end
            local v1884 = u528.frames;
            local v1885 = (#v1884) + 1;
            local v1886 = {};
            v1886.t0 = v1854 - ((0.01666666666666667 * (v1846 - v1852).magnitude) / (v1846 - u514).magnitude);
            v1886.p0 = u514;
            v1886.v0 = u497;
            v1886.a = u497;
            v1886.rot0 = u488.fromaxisangle(v1854 * u521) * u520;
            v1886.offset = 0.2 * v1853;
            v1886.rotv = u497;
            v1886.glassbreaks = {};
            v1884[v1885] = v1886;
         end
         u500:send("newgrenade", u533.name, u528);
      end;
      local u535 = v1806;
      local u536 = v1792;
      local u537 = v1791;
      local f_createnade = f_createnade;
      local u538 = p303;
      local f_throw;
      f_throw = function(p307)
         --[[
            Name: throw
            Upvalues: 
               1 => u493
               2 => u494
               3 => u511
               4 => u510
               5 => u512
               6 => u501
               7 => u491
               8 => u502
               9 => u535
               10 => u536
               11 => u537
               12 => f_createnade
               13 => u391
               14 => u538
   
         --]]
         if (u493.lock or (u494.gammo <= 0)) then
            return;
         end
         if (u511 and (not u510)) then
            local v1887 = tick();
            u510 = true;
            u511 = false;
            p307.cooking = u511;
            u512 = false;
            u501.t = 0;
            u491:add(u502.player(u535, u536.animations.throw));
            u537:delay(0.07000000000000001);
            u537:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => f_createnade
                     2 => u391
                     3 => u501
                     4 => u510
   
               --]]
               f_createnade();
               if (u391) then
                  u501.t = 1;
               end
               u510 = false;
            end);
            u491:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u538
   
               --]]
               if (u538) then
                  u538:setequipped(true);
               end
            end);
         end
      end;
      v1790.throw = f_throw;
      local u539 = v1806;
      local u540 = v1792;
      local u541 = v1797;
      local t_fusetime_264 = v1799;
      local f_pull;
      f_pull = function(p308)
         --[[
            Name: pull
            Upvalues: 
               1 => u511
               2 => u510
               3 => u392
               4 => u491
               5 => u502
               6 => u539
               7 => u540
               8 => u490
               9 => u541
               10 => u515
               11 => t_fusetime_264
               12 => u516
   
         --]]
         local v1888 = tick();
         if (not (u511 or u510)) then
            if (u392) then
               u491:add(u502.reset(u539, 0.1));
               u392 = false;
            end
            u491:add(u502.player(u539, u540.animations.pull));
            local v1889 = u491;
            local u542 = p308;
            local u543 = v1888;
            v1889:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u490
                     2 => u540
                     3 => u541
                     4 => u511
                     5 => u542
                     6 => u515
                     7 => u543
                     8 => t_fusetime_264
                     9 => u516
   
               --]]
               u490.crossspring.a = u540.crossexpansion;
               u541:Destroy();
               u511 = true;
               u542.cooking = u511;
               u515 = u543 + t_fusetime_264;
               u516 = u543 + 5;
            end);
         end
      end;
      v1790.pull = f_pull;
      local u544 = tick();
      local u545 = 1;
      local u546 = nil;
      local v1890 = game:GetService("RunService").RenderStepped;
      local u547 = v1791;
      local u548 = v1790;
      local f_createnade = f_createnade;
      local u549 = v1792;
      local u550 = v1796;
      u546 = v1890:connect(function(p309)
         --[[
            Name: (empty)
            Upvalues: 
               1 => u547
               2 => u511
               3 => u510
               4 => u489
               5 => u548
               6 => u512
               7 => f_createnade
               8 => u515
               9 => u503
               10 => u490
               11 => u549
               12 => u550
               13 => u528
               14 => u545
               15 => u544
               16 => u504
               17 => u485
               18 => u488
               19 => u522
               20 => u498
               21 => u495
               22 => u493
               23 => u546
   
         --]]
         u547.step();
         local v1891 = tick();
         if (u511 and (not u510)) then
            if (u489.alive) then
               if ((not (u515 < v1891)) and u503.keyboard.down.g) then
                  if (((u515 - v1891) % 1) < p309) then
                     u490.crossspring.a = u549.crossexpansion;
                  end
               else
                  u548:throw();
               end
            else
               u511 = false;
               u548.cooking = u511;
               u512 = false;
               f_createnade(true);
               u510 = false;
               u548:setequipped(false);
            end
         end
         if (u550 and u528) then
            local t_time_265 = u528.time;
            local v1892 = u528.frames;
            local t_frames_266 = v1892;
            local v1893 = v1892[u545];
            local v1894 = v1893.glassbreaks;
            local t_glassbreaks_267 = v1894;
            local v1895 = 1;
            local v1896 = #v1894;
            local v1897 = v1896;
            local v1898 = v1895;
            if (not (v1896 <= v1898)) then
               while true do
                  local v1899 = t_glassbreaks_267[v1895];
                  local v1900 = v1899;
                  local v1901 = u544;
                  local v1902 = t_time_265 + v1899.t;
                  if ((v1901 < v1902) and ((t_time_265 + v1900.t) <= v1891)) then
                     u504:breakwindow(v1900.part, nil, nil, u485());
                  end
                  local v1903 = v1895 + 1;
                  v1895 = v1903;
                  local v1904 = v1897;
                  if (v1904 < v1903) then
                     break;
                  end
               end
            end
            local v1905 = t_frames_266[u545 + 1];
            local v1906 = v1905;
            if (v1905 and ((u528.time + v1906.t0) < v1891)) then
               u545 = u545 + 1;
               v1893 = v1906;
            end
            local v1907 = v1891 - (t_time_265 + v1893.t0);
            local v1908 = ((v1893.p0 + (v1907 * v1893.v0)) + (((v1907 * v1907) / 2) * v1893.a)) + v1893.offset;
            local v1909 = v1908;
            u550.CFrame = (u488.fromaxisangle(v1907 * v1893.rotv) * v1893.rot0) + v1908;
            if (u522) then
               u522.Enabled = not workspace:FindPartOnRayWithWhitelist(u498(v1909, u495.cframe.p - v1909), u493.raycastwhitelist);
            end
            if ((t_time_265 + u528.blowuptime) < v1891) then
               u546:Disconnect();
               u550:Destroy();
            end
         end
         u544 = v1891;
      end);
      local t_mainoffset_268 = v1795;
      local u551 = v1806;
      local t_mainpart_269 = v1794;
      local u552 = v1816;
      local u553 = v1815;
      local u554 = v1792;
      local u555 = v1807;
      local f_step;
      f_step = function()
         --[[
            Name: step
            Upvalues: 
               1 => u386
               2 => u495
               3 => t_mainoffset_268
               4 => u551
               5 => t_mainpart_269
               6 => u552
               7 => u505
               8 => u506
               9 => u488
               10 => u507
               11 => f_gunbob
               12 => f_gunsway
               13 => u553
               14 => u508
               15 => u401
               16 => u501
               17 => u554
               18 => u492
               19 => u555
               20 => u440
               21 => u439
   
         --]]
         local v1910 = (((((((((u386.CFrame:inverse() * u495.shakecframe) * t_mainoffset_268) * u551[t_mainpart_269].weld.C0) * u552(u505.p)) * u506(0, 0, 1)) * u488.fromaxisangle(u507.v)) * u506(0, 0, -1)) * f_gunbob(0.7, 1)) * f_gunsway(0)) * u488.interpolate(u553((u508.p / u401.p) * u501.p), u554.equipoffset, u492.p);
         u555.C0 = v1910;
         u440.C0 = v1910 * u551.larm.weld.C0;
         u439.C0 = v1910 * u551.rarm.weld.C0;
      end;
      v1790.step = f_step;
      return v1790;
   end;
   v5.loadgrenade = f_loadgrenade;
   local u556 = v31;
   local t_FindFirstChild_270 = v1789;
   local u557 = t_toObjectSpace_203;
   local u558 = v1355;
   local f_texturemodel = f_texturemodel;
   local u559 = v1360;
   local u560 = v23;
   local u561 = v5;
   local u562 = v7;
   local u563 = v41;
   local u564 = v1378;
   local u565 = v1379;
   local t_CurrentCamera_271 = v1784;
   local u566 = v1419;
   local u567 = v18;
   local u568 = v32;
   local u569 = v12;
   local u570 = v35;
   local u571 = v1364;
   local u572 = v1372;
   local u573 = v10;
   local u574 = t_LocalPlayer_204;
   local u575 = t_Dot_202;
   local u576 = v1373;
   local u577 = v1367;
   local u578 = v30;
   local u579 = v1414;
   local u580 = v1358;
   local u581 = v1408;
   local f_gunbob = f_gunbob;
   local f_gunsway = f_gunsway;
   local u582 = v1417;
   local f_loadknife;
   f_loadknife = function(p310, p311)
      --[[
         Name: loadknife
         Upvalues: 
            1 => f_gunrequire
            2 => t_getGunModel_3
            3 => u556
            4 => t_FindFirstChild_270
            5 => u557
            6 => u558
            7 => f_texturemodel
            8 => u444
            9 => u559
            10 => u386
            11 => u560
            12 => u438
            13 => u561
            14 => u562
            15 => u563
            16 => u564
            17 => u388
            18 => u565
            19 => t_CurrentCamera_271
            20 => u566
            21 => u567
            22 => u391
            23 => u568
            24 => u392
            25 => u390
            26 => u569
            27 => u570
            28 => u571
            29 => u572
            30 => u573
            31 => u574
            32 => u575
            33 => u576
            34 => u577
            35 => u578
            36 => u579
            37 => u580
            38 => u581
            39 => f_gunbob
            40 => f_gunsway
            41 => u582
            42 => u401
            43 => u440
            44 => u439
   
      --]]
      local v1911 = {};
      local v1912 = f_gunrequire(p310);
      local v1913 = v1912;
      local v1914 = t_getGunModel_3(p310):Clone();
      local v1915 = v1914;
      v1911.knife = true;
      v1911.name = v1912.name;
      v1911.type = v1912.type;
      v1911.camodata = p311;
      v1911.texturedata = {};
      local v1916 = u556.new();
      local u583 = {};
      local v1917 = v1912.mainpart;
      local t_mainpart_272 = v1917;
      local t_mainoffset_273 = v1912.mainoffset;
      local v1918 = v1914[v1917];
      local v1919 = v1918;
      local v1920 = v1914[v1912.tip];
      local v1921 = v1914[v1912.blade];
      local u584 = nil;
      local u585 = false;
      local u586 = false;
      local u587 = 0;
      local u588 = 0;
      local u589 = 1000;
      local v1922 = v1912.range0;
      local v1923 = v1912.range1;
      local t_damage0_274 = v1912.damage0;
      local t_damage1_275 = v1912.damage1;
      local v1924 = v1918:Clone();
      local v1925 = v1924;
      v1924.Name = "Handle";
      v1924.Parent = v1914;
      local v1926 = {};
      local t_CFrame_276 = v1924.CFrame;
      local v1927 = v1914:GetChildren();
      local v1928 = v1927;
      local v1929 = t_FindFirstChild_270(v1914, "MenuNodes");
      local v1930 = 1;
      local v1931 = #v1927;
      local v1932 = v1931;
      local v1933 = v1930;
      if (not (v1931 <= v1933)) then
         while true do
            local v1934 = v1928[v1930];
            local v1935 = v1934;
            if (v1934:IsA("BasePart")) then
               if (not ((v1935 == v1925) or (v1935 == v1919))) then
                  local v1936 = u557(t_CFrame_276, v1935.CFrame);
                  local v1937 = u558("Weld");
                  v1937.Part0 = v1925;
                  v1937.Part1 = v1935;
                  v1937.C0 = v1936;
                  v1937.Parent = v1925;
                  local v1938 = v1935.Name;
                  local v1939 = {};
                  v1939.part = v1935;
                  v1939.weld = v1937;
                  v1939.basec0 = v1936;
                  v1939.basetransparency = v1935.Transparency;
                  v1926[v1938] = v1939;
               end
               local v1940 = t_FindFirstChild_270(v1935, "Trail");
               local v1941 = v1940;
               if (v1940 and v1940:IsA("Trail")) then
                  u584 = v1941;
                  u584.Enabled = false;
               end
               v1935.Anchored = false;
               v1935.CanCollide = false;
            end
            local v1942 = v1930 + 1;
            v1930 = v1942;
            local v1943 = v1932;
            if (v1943 < v1942) then
               break;
            end
         end
      end
      f_texturemodel(p311, v1915);
      if (v1929) then
         v1929:Destroy();
      end
      local v1944 = v1915:GetChildren();
      local v1945 = v1944;
      local v1946 = 1;
      local v1947 = #v1944;
      local v1948 = v1947;
      local v1949 = v1946;
      if (not (v1947 <= v1949)) then
         while true do
            local v1950 = false;
            local v1951 = v1945[v1946];
            local v1952 = v1951;
            v1911.texturedata[v1951] = {};
            local v1953 = v1951:GetChildren();
            local v1954 = v1953;
            local v1955 = 1;
            local v1956 = #v1953;
            local v1957 = v1956;
            local v1958 = v1955;
            if (v1956 <= v1958) then
               v1950 = true;
            else
               while true do
                  local v1959 = v1954[v1955];
                  local v1960 = v1959;
                  if (v1959:IsA("Texture") or v1959:IsA("Decal")) then
                     local v1961 = v1911.texturedata[v1952];
                     local v1962 = {};
                     v1962.Transparency = v1960.Transparency;
                     v1961[v1960] = v1962;
                  end
                  local v1963 = v1955 + 1;
                  v1955 = v1963;
                  local v1964 = v1957;
                  if (v1964 < v1963) then
                     break;
                  end
               end
               v1950 = true;
            end
            if (v1950) then
               if (v1952:IsA("BasePart")) then
                  v1952.CastShadow = false;
               end
               local v1965 = v1946 + 1;
               v1946 = v1965;
               local v1966 = v1948;
               if (v1966 < v1965) then
                  break;
               end
            end
         end
      end
      v1926.camodata = v1911.texturedata;
      local v1967 = u558("Motor6D");
      v1967.Part0 = u444;
      v1967.Part1 = v1925;
      v1967.Parent = v1925;
      local v1968 = u558("Motor6D");
      local v1969 = {};
      local v1970 = {};
      v1970.C0 = u559;
      v1969.weld = v1970;
      v1969.basec0 = u559;
      v1926[t_mainpart_272] = v1969;
      local v1971 = {};
      local v1972 = {};
      v1972.C0 = v1913.larmoffset;
      v1971.weld = v1972;
      v1971.basec0 = v1913.larmoffset;
      v1926.larm = v1971;
      local v1973 = {};
      local v1974 = {};
      v1974.C0 = v1913.rarmoffset;
      v1973.weld = v1974;
      v1973.basec0 = v1913.rarmoffset;
      v1926.rarm = v1973;
      local v1975 = {};
      local v1976 = {};
      v1976.C0 = v1913.knifeoffset;
      v1975.weld = v1976;
      v1975.basec0 = v1913.knifeoffset;
      v1926.knife = v1975;
      v1968.Part0 = u386;
      v1968.Part1 = v1919;
      v1968.Parent = v1919;
      local v1977 = v1913.equipoffset;
      local v1978 = u560.interpolator(v1913.sprintoffset);
      local v1979 = u560.interpolator(v1913.proneoffset);
      local u590 = nil;
      local u591 = v1915;
      local f_destroy;
      f_destroy = function(p312)
         --[[
            Name: destroy
            Upvalues: 
               1 => u591
   
         --]]
         if (u591:FindFirstChild("Sound")) then
            u591.Sound.Parent = nil;
         end
         u591:Destroy();
      end;
      v1911.destroy = f_destroy;
      local u592 = v1913;
      local u593 = t_mainpart_272;
      local u594 = v1915;
      local u595 = v1926;
      local f_setequipped;
      f_setequipped = function(p313, p314, p315)
         --[[
            Name: setequipped
            Upvalues: 
               1 => u585
               2 => u438
               3 => u561
               4 => u562
               5 => u592
               6 => u593
               7 => u563
               8 => u590
               9 => u564
               10 => u388
               11 => u565
               12 => u594
               13 => t_CurrentCamera_271
               14 => u584
               15 => u566
               16 => u567
               17 => u586
               18 => u391
               19 => u589
               20 => u568
               21 => u595
               22 => u392
   
         --]]
         if (p314 and (not (u585 and u438))) then
            if (u561.alive) then
               u562:setcrosssettings(u592.type, u592.crosssize, u592.crossspeed, u592.crossdamper, u593);
               u562:updatefiremode("KNIFE");
               u562:updateammo("KNIFE");
               u563.play("equipCloth", 0.25);
               u563.play(u592.soundClassification .. "Equip", 0.25);
               u438 = true;
               u590 = false;
               u564:clear();
               if (u388) then
                  u388:setequipped(false);
               end
               local v1980 = u564;
               local u596 = p315;
               local u597 = p313;
               v1980:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u561
                        2 => u592
                        3 => u565
                        4 => u562
                        5 => u594
                        6 => t_CurrentCamera_271
                        7 => u584
                        8 => u563
                        9 => u566
                        10 => u596
                        11 => u585
                        12 => u388
                        13 => u597
                        14 => u438
                        15 => u567
                        16 => u586
                        17 => u391
                        18 => u589
   
                  --]]
                  u561:setbasewalkspeed(u592.walkspeed);
                  u565.s = u592.sprintspeed;
                  u562:setcrosssize(u592.crosssize);
                  if (u594) then
                     u594.Parent = t_CurrentCamera_271;
                  end
                  if (u584) then
                     u584.Enabled = false;
                  end
                  local t_soundClassification_277 = u592.soundClassification;
                  if (t_soundClassification_277 == "saber") then
                     u563.play("saberLoop", 0.25, 1, u594, false, true);
                  end
                  local v1981 = u566;
                  local v1982;
                  if (u596) then
                     v1982 = 32;
                  else
                     v1982 = 16;
                  end
                  v1981.s = v1982;
                  u566.t = 0;
                  u585 = true;
                  u388 = u597;
                  u438 = false;
                  u563.play("equipCloth", 0.25);
                  u567:send("equip", 3);
                  u586 = false;
                  u561.grenadehold = false;
                  if (u391) then
                     u565.t = 1;
                  end
                  local v1983;
                  if (u596) then
                     v1983 = 2000;
                  else
                     v1983 = 1000;
                  end
                  u589 = v1983;
               end);
               if (p315) then
                  u564:delay(0.05);
                  local v1984 = u564;
                  local u598 = p313;
                  local u599 = p315;
                  v1984:add(function()
                     --[[
                        Name: (empty)
                        Upvalues: 
                           1 => u598
                           2 => u599
   
                     --]]
                     u598:shoot(u599);
                  end);
               end
            else
               return;
            end
         else
            if ((not p314) and u585) then
               u586 = false;
               u590 = false;
               u566.t = 1;
               u564:add(u568.reset(u595, 0.1));
               u564:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u585
                        2 => u594
                        3 => u392
                        4 => u388
   
                  --]]
                  u585 = false;
                  local v1985 = u594:FindFirstChildOfClass("Sound");
                  local v1986 = v1985;
                  if (v1985) then
                     v1986:Stop();
                  end
                  u594.Parent = nil;
                  u392 = false;
                  u388 = nil;
               end);
            end
         end
         if (p315 == "death") then
            p313:destroy();
         end
      end;
      v1911.setequipped = f_setequipped;
      local f_inspecting;
      f_inspecting = function(p316)
         --[[
            Name: inspecting
            Upvalues: 
               1 => u590
   
         --]]
         return u590;
      end;
      v1911.inspecting = f_inspecting;
      local f_isaiming;
      f_isaiming = function()
         --[[
            Name: isaiming
         --]]
         return false;
      end;
      v1911.isaiming = f_isaiming;
      local u600 = v1926;
      local u601 = v1913;
      local f_playanimation;
      f_playanimation = function(p317, p318)
         --[[
            Name: playanimation
            Upvalues: 
               1 => u586
               2 => u438
               3 => u564
               4 => u392
               5 => u568
               6 => u600
               7 => u565
               8 => u590
               9 => u601
               10 => u391
   
         --]]
         if (not (u586 or u438)) then
            u564:clear();
            if (u392) then
               u564:add(u568.reset(u600, 0.05));
            end
            u392 = true;
            u565.t = 0;
            if (p318 == "inspect") then
               u590 = true;
            end
            u564:add(u568.player(u600, u601.animations[p318]));
            local v1987 = u564;
            local u602 = p318;
            v1987:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u564
                     2 => u568
                     3 => u600
                     4 => u601
                     5 => u602
                     6 => u392
                     7 => u391
                     8 => u565
                     9 => u590
   
               --]]
               u564:add(u568.reset(u600, u601.animations[u602].resettime));
               u392 = false;
               u564:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u391
                        2 => u565
                        3 => u590
   
                  --]]
                  if (u391) then
                     u565.t = 1;
                  end
                  u590 = false;
               end);
            end);
         end
      end;
      v1911.playanimation = f_playanimation;
      local u603 = v1926;
      local f_reloadcancel;
      f_reloadcancel = function(p319, p320)
         --[[
            Name: reloadcancel
            Upvalues: 
               1 => u564
               2 => u568
               3 => u603
               4 => u390
               5 => u392
               6 => u391
               7 => u565
   
         --]]
         if (p320) then
            u564:clear();
            u564:add(u568.reset(u603, 0.2));
            u390 = false;
            u392 = false;
            u564:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u391
                     2 => u565
   
               --]]
               if (u391) then
                  u565.t = 1;
               end
            end);
         end
      end;
      v1911.reloadcancel = f_reloadcancel;
      local u604 = v1919;
      local f_dropguninfo;
      f_dropguninfo = function(p321)
         --[[
            Name: dropguninfo
            Upvalues: 
               1 => u604
   
         --]]
         return u604.Position;
      end;
      v1911.dropguninfo = f_dropguninfo;
      local u605 = v1926;
      local u606 = v1913;
      local f_shoot;
      f_shoot = function(p322, p323, p324)
         --[[
            Name: shoot
            Upvalues: 
               1 => u569
               2 => u590
               3 => u586
               4 => u565
               5 => u567
               6 => u588
               7 => u390
               8 => u584
               9 => u392
               10 => u564
               11 => u568
               12 => u605
               13 => u563
               14 => u606
               15 => u587
               16 => u583
               17 => u391
   
         --]]
         if (u569.lock) then
            return;
         end
         if (u590) then
            p322:reloadcancel(true);
            u590 = false;
         end
         if (not u586) then
            local v1988 = false;
            local t_s_278 = u565.s;
            local v1989 = tick();
            local v1990 = v1989;
            u567:send("stab");
            local v1991 = u588;
            local v1992;
            if (v1989 < v1991) then
               v1992 = u588;
               if (not v1992) then
                  v1988 = true;
               end
            else
               v1988 = true;
            end
            if (v1988) then
               v1992 = v1990;
            end
            u588 = v1992;
            u565.t = 0;
            u565.s = 50;
            u586 = true;
            u390 = true;
            if (u584) then
               u584.Enabled = true;
            end
            if (u392) then
               u564:add(u568.reset(u605, 0.1));
               u392 = false;
            end
            local v1993;
            if (p323) then
               v1993 = "quickstab";
            else
               v1993 = p324;
               if (not v1993) then
                  v1993 = "stab1";
               end
            end
            u563.play(u606.soundClassification, 0.25);
            u587 = tick() + u606.hitdelay[v1993];
            u583 = {};
            u564:add(u568.player(u605, u606.animations[v1993]));
            local v1994 = u564;
            local u607 = v1993;
            v1994:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u564
                     2 => u568
                     3 => u605
                     4 => u606
                     5 => u607
   
               --]]
               u564:add(u568.reset(u605, u606.animations[u607].resettime));
            end);
            if (u391 or (v1993 == "quickstab")) then
               u564:delay(u606.animations[v1993].resettime * 0.75);
               u564:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u391
                        2 => u565
   
                  --]]
                  if (u391) then
                     u565.t = 1;
                  end
               end);
            end
            local v1995 = u564;
            local u608 = t_s_278;
            v1995:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u586
                     2 => u565
                     3 => u608
                     4 => u390
                     5 => u584
   
               --]]
               u586 = false;
               u565.s = u608;
               u390 = false;
               if (u584) then
                  u584.Enabled = false;
               end
            end);
         end
      end;
      v1911.shoot = f_shoot;
      local u609 = t_damage1_275;
      local u610 = t_damage0_274;
      local u611 = v1913;
      local f_knifehitdetection;
      f_knifehitdetection = function(p325, p326, p327, p328, p329)
         --[[
            Name: knifehitdetection
            Upvalues: 
               1 => u583
               2 => u570
               3 => u571
               4 => u572
               5 => u573
               6 => t_FindFirstChild_270
               7 => u574
               8 => u575
               9 => u386
               10 => u609
               11 => u610
               12 => u611
               13 => u567
               14 => u562
   
         --]]
         local v1996 = nil;
         if (not (u583[p325.Parent] or u583[p325])) then
            local t_Name_279 = p325.Name;
            if (t_Name_279 == "Window") then
               u570:breakwindow(p325, p326, p327, u571(), nil, time, p328.Origin, p328.Direction);
               v1996 = p325;
            else
               local t_Name_280 = p325.Parent.Name;
               if (t_Name_280 == "Dead") then
                  u570:bloodhit(p325.Position, p325.CFrame.lookVector);
                  v1996 = p325.Parent;
               else
                  if (p325:IsDescendantOf(u572)) then
                     local v1997 = u573.getplayerhit(p325);
                     local v1998 = v1997;
                     local v1999 = t_FindFirstChild_270(p325.Parent, "Head");
                     local v2000 = t_FindFirstChild_270(p325.Parent, "Torso");
                     if (v1997) then
                        local v2001 = v1998.TeamColor;
                        local t_TeamColor_281 = u574.TeamColor;
                        if (((not (v2001 == t_TeamColor_281)) and v1999) and v2000) then
                           local v2002 = (((u575(v2000.CFrame.lookVector, (p326 - u386.Position).unit) * 0.5) + 0.5) * (u609 - u610)) + u610;
                           if (v2002 > 100) then
                           end
                           local t_Name_282 = p325.Name;
                           if (t_Name_282 == "Head") then
                              v2002 = v2002 * u611.multhead;
                           else
                              local t_Name_283 = p325.Name;
                              if (t_Name_283 == "Torso") then
                                 v2002 = v2002 * u611.multtorso;
                              end
                           end
                           u567:send("knifehit", v1998, tick(), p325);
                           u562:firehitmarker(p325.Name == "Head");
                           u570:bloodhit(p326, true, v2002, u571(0, -8, 0) + ((p326 - u386.Position).unit * 8));
                        end
                     end
                     v1996 = p325.Parent;
                  else
                     if (p329) then
                        u570:bullethit(p325, p326, p327);
                        v1996 = p325;
                     end
                  end
               end
            end
            if (v1996) then
               u583[v1996] = true;
            end
         end
      end;
      local u612 = v1920;
      local u613 = v1921;
      local f_knifehitdetection = f_knifehitdetection;
      local u614 = t_mainoffset_273;
      local u615 = v1926;
      local u616 = t_mainpart_272;
      local u617 = v1979;
      local u618 = v1978;
      local u619 = v1913;
      local u620 = v1968;
      local u621 = v1967;
      local u622 = v1916;
      local u623 = v1911;
      local f_step;
      f_step = function(p330)
         --[[
            Name: step
            Upvalues: 
               1 => u586
               2 => u573
               3 => u576
               4 => u612
               5 => u613
               6 => u577
               7 => u578
               8 => f_knifehitdetection
               9 => u386
               10 => u614
               11 => u615
               12 => u616
               13 => u617
               14 => u579
               15 => u580
               16 => u560
               17 => u581
               18 => f_gunbob
               19 => f_gunsway
               20 => u618
               21 => u582
               22 => u401
               23 => u565
               24 => u619
               25 => u566
               26 => u620
               27 => u440
               28 => u439
               29 => u621
               30 => u622
               31 => u561
               32 => u623
   
         --]]
         if (u586) then
            local v2003 = u573.getallparts();
            local v2004 = v2003;
            v2003[(#v2003) + 1] = u576;
            local v2005 = u612.CFrame.p;
            local v2006 = u613.CFrame.p;
            local t_p_284 = v2005;
            local v2007 = v2006 - v2005;
            local v2008 = v2007;
            local v2009 = v2007.Magnitude;
            local t_Magnitude_285 = v2009;
            local v2010 = 0;
            local t_Magnitude_286 = v2009;
            local v2011 = v2010;
            if (not (v2009 <= v2011)) then
               while true do
                  local v2012 = u577(u578.cframe.p, (t_p_284 + ((v2010 / t_Magnitude_285) * v2008)) - u578.cframe.p);
                  local v2013 = v2012;
                  local v2014, v2015, v2016 = workspace:FindPartOnRayWithWhitelist(v2012, v2004);
                  local v2017 = v2014;
                  local v2018 = v2015;
                  local v2019 = v2016;
                  if (v2014) then
                     f_knifehitdetection(v2017, v2018, v2019, v2013, v2010 == 0);
                  end
                  local v2020 = v2010 + 0.1;
                  v2010 = v2020;
                  local v2021 = t_Magnitude_286;
                  if (v2021 < v2020) then
                     break;
                  end
               end
            end
         end
         local v2022 = (((((((((u386.CFrame:inverse() * u578.shakecframe) * u614) * u615[u616].weld.C0) * u617(u579.p)) * u580(0, 0, 1)) * u560.fromaxisangle(u581.v)) * u580(0, 0, -1)) * f_gunbob(0.7, 1)) * f_gunsway(0)) * u560.interpolate(u618((u582.p / u401.p) * u565.p), u619.equipoffset, u566.p);
         u620.C0 = v2022;
         u440.C0 = v2022 * u560.interpolate(u615.larm.weld.C0, u619.larmsprintoffset, (u582.p / u401.p) * u565.p);
         u439.C0 = v2022 * u560.interpolate(u615.rarm.weld.C0, u619.rarmsprintoffset, (u582.p / u401.p) * u565.p);
         u621.C0 = u615.knife.weld.C0;
         u622:step();
         if (not u561.alive) then
            u623:setequipped(false);
         end
      end;
      v1911.step = f_step;
      return v1911;
   end;
   v5.loadknife = f_loadknife;
   local u624 = 0;
   local v2023 = shared.require("InputType");
   local u625 = v42;
   local u626 = v31;
   local f_weldmodel = f_weldmodel;
   local f_addgun = f_addgun;
   local f_removegun = f_removegun;
   local u627 = v1348;
   local u628 = v1355;
   local u629 = v1360;
   local u630 = v23;
   local u631 = v5;
   local u632 = v25;
   local u633 = v1366;
   local u634 = v1387;
   local u635 = v30;
   local u636 = v7;
   local u637 = v1364;
   local u638 = v18;
   local u639 = v41;
   local u640 = v1378;
   local u641 = v1379;
   local u642 = v1419;
   local t_CurrentCamera_287 = v1784;
   local u643 = v33;
   local u644 = v35;
   local u645 = v32;
   local t_FindFirstChild_288 = v1789;
   local u646 = v1389;
   local u647 = v13;
   local u648 = t_PlayerGui_205;
   local u649 = v8;
   local u650 = v12;
   local u651 = t_LocalPlayer_204;
   local u652 = v2023;
   local f_pickv3 = f_pickv3;
   local u653 = v1367;
   local u654 = v1350;
   local u655 = v1353;
   local u656 = v1352;
   local u657 = v21;
   local u658 = v34;
   local u659 = v14;
   local f_bfgsounds = f_bfgsounds;
   local u660 = v1417;
   local u661 = v1368;
   local u662 = v1380;
   local u663 = v1408;
   local f_gunbob = f_gunbob;
   local f_gunsway = f_gunsway;
   local u664 = v11;
   local f_loadgun;
   f_loadgun = function(p331, p332, p333, p334, p335, p336, p337)
      --[[
         Name: loadgun
         Upvalues: 
            1 => u625
            2 => f_gunrequire
            3 => t_getGunModel_3
            4 => u626
            5 => f_weldmodel
            6 => f_addgun
            7 => f_removegun
            8 => u627
            9 => u628
            10 => u629
            11 => u630
            12 => u631
            13 => u632
            14 => u633
            15 => u634
            16 => u399
            17 => u635
            18 => u636
            19 => f_updatewalkspeed
            20 => u637
            21 => u438
            22 => u638
            23 => u390
            24 => u639
            25 => u640
            26 => u388
            27 => u641
            28 => u642
            29 => t_CurrentCamera_287
            30 => u386
            31 => u643
            32 => u391
            33 => u644
            34 => u645
            35 => u392
            36 => t_FindFirstChild_288
            37 => u441
            38 => u442
            39 => u646
            40 => u647
            41 => u648
            42 => u649
            43 => u650
            44 => u651
            45 => u652
            46 => u393
            47 => f_pickv3
            48 => u653
            49 => u624
            50 => u654
            51 => u655
            52 => u656
            53 => u657
            54 => u658
            55 => u659
            56 => f_bfgsounds
            57 => u660
            58 => u401
            59 => u661
            60 => u662
            61 => u663
            62 => f_gunbob
            63 => f_gunsway
            64 => u440
            65 => u439
            66 => u664
   
      --]]
      local v2024 = false;
      local v2025 = u625(f_gunrequire(p331), p334, p335);
      local v2026 = v2025;
      local v2027 = t_getGunModel_3(p331):Clone();
      local v2028 = v2027;
      local v2029 = {};
      v2029.burst = 0;
      v2029.auto = false;
      v2029.attachments = p334;
      v2029.camodata = p336;
      v2029.texturedata = {};
      v2029.transparencydata = {};
      v2029.data = v2025;
      v2029.type = v2025.type;
      v2029.ammotype = v2025.ammotype;
      v2029.name = v2025.name;
      v2029.magsize = v2025.magsize;
      v2029.sparerounds = v2025.sparerounds;
      v2029.gunnumber = p337;
      local u665 = false;
      local v2030 = u626.new();
      local v2031 = v2025.mainpart;
      local t_mainpart_289 = v2031;
      local t_mainoffset_290 = v2025.mainoffset;
      local v2032 = v2027[v2031];
      local v2033 = v2032;
      local u666 = false;
      local u667 = false;
      local v2034 = f_weldmodel;
      local u668 = v2027;
      local v2035 = v2034(u668, v2032, p334, v2025, p336, p335);
      if (v2025.variablefirerate) then
         u668 = v2026.firerate[1];
         if (not u668) then
            v2024 = true;
         end
      else
         v2024 = true;
      end
      if (v2024) then
         u668 = v2026.firerate;
      end
      local u669 = v2026.firemodes;
      local u670 = 1;
      local v2036 = p333;
      if (not v2036) then
         v2036 = v2026.sparerounds;
      end
      local u671 = math.ceil(v2036);
      local t_chamber_291 = v2026.chamber;
      local u672 = v2026.magsize;
      local u673 = p332 or u672;
      local u674 = 0;
      local t_range0_292 = v2026.range0;
      local t_range1_293 = v2026.range1;
      local t_damage0_294 = v2026.damage0;
      local t_damage1_295 = v2026.damage1;
      f_addgun(v2029);
      local f_remove;
      f_remove = function(p338)
         --[[
            Name: remove
            Upvalues: 
               1 => f_removegun
   
         --]]
         f_removegun(p338);
      end;
      v2029.remove = f_remove;
      local v2037 = v2028:GetChildren();
      local v2038 = v2037;
      local v2039 = 1;
      local v2040 = #v2037;
      local v2041 = v2040;
      local v2042 = v2039;
      if (not (v2040 <= v2042)) then
         while true do
            local v2043 = v2038[v2039];
            local v2044 = v2043;
            v2029.texturedata[v2043] = {};
            v2029.transparencydata[v2043] = v2043.Transparency;
            local v2045 = v2043:GetChildren();
            local v2046 = v2045;
            local v2047 = 1;
            local v2048 = #v2045;
            local v2049 = v2048;
            local v2050 = v2047;
            if (not (v2048 <= v2050)) then
               while true do
                  local v2051 = v2046[v2047];
                  local v2052 = v2051;
                  if (v2051:IsA("Texture") or v2051:IsA("Decal")) then
                     local v2053 = v2029.texturedata[v2044];
                     local v2054 = {};
                     v2054.Transparency = v2052.Transparency;
                     v2053[v2052] = v2054;
                  end
                  local v2055 = v2047 + 1;
                  v2047 = v2055;
                  local v2056 = v2049;
                  if (v2056 < v2055) then
                     break;
                  end
               end
            end
            local t_Name_349 = v2044.Name;
            if (t_Name_349 == "LaserLight") then
               u627:addlaser(v2044);
            end
            if (v2044:IsA("BasePart")) then
               v2044.CastShadow = false;
            end
            local v2057 = v2039 + 1;
            v2039 = v2057;
            local v2058 = v2041;
            if (v2058 < v2057) then
               break;
            end
         end
      end
      v2035.camodata = v2029.texturedata;
      local v2059 = u628("Motor6D");
      local v2060 = {};
      v2060.part = v2033;
      v2060.basetransparency = v2033.Transparency;
      local v2061 = {};
      v2061.C0 = u629;
      v2060.weld = v2061;
      v2060.basec0 = u629;
      v2035[t_mainpart_289] = v2060;
      local v2062 = {};
      local v2063 = {};
      v2063.C0 = v2026.larmoffset;
      v2062.weld = v2063;
      v2062.basec0 = v2026.larmoffset;
      v2035.larm = v2062;
      local v2064 = {};
      local v2065 = {};
      v2065.C0 = v2026.rarmoffset;
      v2064.weld = v2065;
      v2064.basec0 = v2026.rarmoffset;
      v2035.rarm = v2064;
      local v2066 = v2028[v2026.barrel];
      local v2067 = v2066;
      v2029.barrel = v2066;
      local v2068 = v2028[v2026.sight];
      if (v2026.altsight) then
         local v2069 = v2028[v2026.altsight];
      end
      local t_hideflash_296 = v2026.hideflash;
      local v2070 = v2026.hideminimap;
      local v2071 = v2026.hiderange or 50;
      local v2072 = CFrame.new;
      local v2073 = CFrame.Angles;
      local v2074 = math.pi / 180;
      local v2075 = u630.interpolator(v2026.sprintoffset);
      local t_interpolator_297 = u630.interpolator;
      local v2076 = v2026.climboffset;
      if (not v2076) then
         v2076 = v2072(-0.9, -1.48, 0.43) * v2073(-0.5, 0.3, 0);
      end
      local v2077 = false;
      local v2078 = t_interpolator_297(v2076);
      local t_interpolator_298 = u630.interpolator;
      local v2079;
      if (u631.disabledynamicstance) then
         v2079 = v2072();
         if (not v2079) then
            v2077 = true;
         end
      else
         v2077 = true;
      end
      if (v2077) then
         v2079 = v2026.crouchoffset;
         if (not v2079) then
            v2079 = v2072(-0.45, 0.1, 0.1) * v2073(0, 0, 30 * v2074);
         end
      end
      local v2080 = false;
      local v2081 = t_interpolator_298(v2079);
      local t_interpolator_299 = u630.interpolator;
      local v2082;
      if (u631.disabledynamicstance) then
         v2082 = v2072();
         if (not v2082) then
            v2080 = true;
         end
      else
         v2080 = true;
      end
      if (v2080) then
         v2082 = v2072(-0.3, 0.25, 0.2) * v2073(0, 0, 10 * v2074);
      end
      local v2083 = t_interpolator_299(v2082);
      local v2084 = u630.interpolator(v2035[v2026.bolt].basec0, v2035[v2026.bolt].basec0 * v2026.boltoffset);
      local v2085 = u632.new(u633);
      local v2086 = u632.new(u633);
      local v2087 = u632.new(u633);
      local v2088 = u632.new(0);
      local v2089 = v2088;
      v2088.s = 12;
      local v2090 = {};
      v2029.aimsightdata = v2090;
      local u675 = {};
      local u676 = nil;
      local u677 = 0;
      local u678 = 1;
      local u679 = nil;
      local u680 = nil;
      local u681 = false;
      local u682 = false;
      local u683 = false;
      local u684 = true;
      local u685 = 0;
      local u686 = 0;
      local u687 = v2090;
      local u688 = v2026;
      local f_updateaimstatus;
      f_updateaimstatus = function()
         --[[
            Name: updateaimstatus
            Upvalues: 
               1 => u675
               2 => u687
               3 => u678
               4 => u668
               5 => u670
               6 => u665
               7 => u634
               8 => u399
               9 => u635
               10 => u688
               11 => u636
               12 => f_updatewalkspeed
   
         --]]
         local v2091 = false;
         u675 = u687[u678];
         local v2092;
         if (u675.variablefirerate) then
            v2092 = u675.firerate[u670];
            if (not v2092) then
               v2091 = true;
            end
         else
            v2091 = true;
         end
         if (v2091) then
            v2092 = u675.firerate;
         end
         u668 = v2092;
         local v2093 = 1;
         local v2094 = #u687;
         local v2095 = v2094;
         local v2096 = v2093;
         if (not (v2094 <= v2096)) then
            while true do
               local v2097 = false;
               local t_sightspring_301 = u687[v2093].sightspring;
               local v2099;
               if (u665) then
                  local v2098 = u678;
                  if (v2093 == v2098) then
                     v2099 = u634.t;
                     if (not v2099) then
                        v2097 = true;
                     end
                  else
                     v2097 = true;
                  end
               else
                  v2097 = true;
               end
               if (v2097) then
                  v2099 = 0;
               end
               t_sightspring_301.t = v2099;
               u687[v2093].sightspring.s = u675.aimspeed;
               local v2100 = v2093 + 1;
               v2093 = v2100;
               local v2101 = v2095;
               if (v2101 < v2100) then
                  break;
               end
            end
         end
         local v2102 = false;
         local v2103;
         if (u665) then
            v2103 = u675.aimwalkspeedmult;
            if (not v2103) then
               v2102 = true;
            end
         else
            v2102 = true;
         end
         if (v2102) then
            v2103 = 1;
         end
         local v2104 = false;
         u399 = v2103;
         local t_shakespring_300 = u635.shakespring;
         local v2105;
         if (u665) then
            v2105 = u675.aimcamkickspeed;
            if (not v2105) then
               v2104 = true;
            end
         else
            v2104 = true;
         end
         if (v2104) then
            v2105 = u688.camkickspeed;
         end
         t_shakespring_300.s = v2105;
         if (u675.blackscope) then
            u636:setscopesettings(u675);
         end
         u636:updatesightmark(u675.sightpart, u675.centermark);
         f_updatewalkspeed();
      end;
      local v2106 = {};
      v2106.sight = v2026.sight;
      v2106.sightpart = v2028[v2026.sight];
      v2106.aimoffset = v2072();
      v2106.aimrotkickmin = v2026.aimrotkickmin;
      v2106.aimrotkickmax = v2026.aimrotkickmax;
      v2106.aimtranskickmin = v2026.aimtranskickmin * u637(1, 1, 0.5);
      v2106.aimtranskickmax = v2026.aimtranskickmax * u637(1, 1, 0.5);
      v2106.larmaimoffset = v2026.larmaimoffset;
      v2106.rarmaimoffset = v2026.rarmaimoffset;
      v2106.aimcamkickmin = v2026.aimcamkickmin;
      v2106.aimcamkickmax = v2026.aimcamkickmax;
      v2106.aimcamkickspeed = v2026.aimcamkickspeed;
      v2106.aimspeed = v2026.aimspeed;
      v2106.aimwalkspeedmult = v2026.aimwalkspeedmult;
      v2106.magnifyspeed = v2026.magnifyspeed;
      v2106.zoom = v2026.zoom;
      local v2107 = v2026.prezoom;
      if (not v2107) then
         v2107 = v2026.zoom ^ 0.25;
      end
      v2106.prezoom = v2107;
      v2106.scopebegin = v2026.scopebegin or 0.9;
      v2106.firerate = v2026.firerate;
      v2106.aimedfirerate = v2026.aimedfirerate;
      v2106.variablefirerate = v2026.variablefirerate;
      v2106.onfireanim = v2026.onfireanim or "";
      v2106.aimreloffset = v2026.aimreloffset;
      v2106.aimzdist = v2026.aimzdist;
      v2106.aimzoffset = v2026.aimzoffset;
      v2106.aimspringcancel = v2026.aimspringcancel;
      v2106.sightsize = v2026.sightsize;
      v2106.sightr = v2026.sightr;
      v2106.nosway = v2026.nosway;
      v2106.swayamp = v2026.swayamp;
      v2106.swayspeed = v2026.swayspeed;
      v2106.steadyspeed = v2026.steadyspeed;
      v2106.breathspeed = v2026.breathspeed;
      v2106.recoverspeed = v2026.recoverspeed;
      v2106.scopeid = v2026.scopeid;
      v2106.scopecolor = v2026.scopecolor;
      v2106.sightcolor = v2026.sightcolor;
      v2106.scopelenscolor = v2026.lenscolor;
      v2106.scopelenstrans = v2026.lenstrans;
      v2106.scopeimagesize = v2026.scopeimagesize;
      v2106.scopesize = v2026.scopesize;
      v2106.reddot = v2026.reddot;
      v2106.midscope = v2026.midscope;
      v2106.blackscope = v2026.blackscope;
      v2106.centermark = v2026.centermark;
      v2106.pullout = v2026.pullout;
      v2106.zoompullout = v2026.zoompullout;
      local u689 = v2106;
      local u690 = v2028;
      local u691 = t_mainoffset_290;
      local u692 = v2033;
      local u693 = v2072;
      local u694 = v2090;
      local f_addnewsight;
      f_addnewsight = function(p339)
         --[[
            Name: addnewsight
            Upvalues: 
               1 => u689
               2 => u690
               3 => u691
               4 => u692
               5 => u637
               6 => u693
               7 => u630
               8 => u632
               9 => u694
   
         --]]
         local v2108 = {};
         local g_next_302 = next;
         local v2109 = u689;
         local v2110 = nil;
         while true do
            local v2111, v2112 = g_next_302(v2109, v2110);
            local v2113 = v2111;
            local v2114 = v2112;
            if (v2111) then
               v2110 = v2113;
               v2108[v2113] = v2114;
            else
               break;
            end
         end
         local g_next_303 = next;
         local v2115 = p339;
         local v2116 = nil;
         while true do
            local v2117, v2118 = g_next_303(v2115, v2116);
            local v2119 = v2117;
            local v2120 = v2118;
            if (v2117) then
               v2116 = v2119;
               v2108[v2119] = v2120;
            else
               break;
            end
         end
         if (u690:FindFirstChild(v2108.sight)) then
            local v2121 = false;
            local v2122 = (u691:inverse() * u690[v2108.sight].CFrame:inverse()) * u692.CFrame;
            local v2123;
            if (v2108.aimzdist) then
               v2123 = u637(0, 0, v2108.aimzdist + (v2108.aimzoffset or 0));
               if (not v2123) then
                  v2121 = true;
               end
            else
               v2121 = true;
            end
            if (v2121) then
               v2123 = (v2122.p * u637(0, 0, 1)) - u637(0, 0, 0);
            end
            local v2124 = v2122 - v2123;
            local v2125 = v2108.aimreloffset;
            if (not v2125) then
               v2125 = u693();
            end
            local v2126 = v2124 * v2125;
            v2108.sightpart = u690[v2108.sight];
            v2108.aimoffset = v2126;
            v2108.aimoffsetp = v2126.p;
            v2108.aimoffsetr = u630.toaxisangle(v2126);
            v2108.larmaimoffsetp = v2108.larmaimoffset.p;
            v2108.larmaimoffsetr = u630.toaxisangle(v2108.larmaimoffset);
            v2108.rarmaimoffsetp = v2108.rarmaimoffset.p;
            v2108.rarmaimoffsetr = u630.toaxisangle(v2108.rarmaimoffset);
            v2108.sightspring = u632.new(0);
            u694[(#u694) + 1] = v2108;
         end
      end;
      f_addnewsight(v2106);
      local v2127 = v2026.altaimdata;
      if (not v2127) then
         v2127 = {};
      end
      local g_next_304 = next;
      local v2128 = v2127;
      local v2129 = nil;
      while true do
         local v2130, v2131 = g_next_304(v2128, v2129);
         local v2132 = v2130;
         local v2133 = v2131;
         if (v2130) then
            v2129 = v2132;
            f_addnewsight(v2133);
         else
            break;
         end
      end
      f_updateaimstatus();
      local v2134 = u632.new();
      local v2135 = v2134;
      v2085.s = v2026.modelkickspeed;
      v2086.s = v2026.modelkickspeed;
      v2085.d = v2026.modelkickdamper;
      v2086.d = v2026.modelkickdamper;
      v2087.s = v2026.hipfirespreadrecover;
      v2087.d = v2026.hipfirestability or 0.7;
      u634.d = 0.95;
      v2134.s = 16;
      v2134.d = 0.95;
      local u695 = v2028;
      local f_destroy;
      f_destroy = function(p340, p341)
         --[[
            Name: destroy
            Upvalues: 
               1 => u627
               2 => u695
   
         --]]
         p340:remove();
         u627:deactivatelasers(p341, u695);
         u627:destroysights(p341, u695);
         u695:Destroy();
      end;
      v2029.destroy = f_destroy;
      local u696 = v2026;
      local f_updatefiremodestability;
      f_updatefiremodestability = function()
         --[[
            Name: updatefiremodestability
            Upvalues: 
               1 => u696
               2 => u677
               3 => u669
               4 => u670
   
         --]]
         local v2136 = false;
         local v2137 = u696.fmode1 or 0;
         local v2138 = u696.fmode2 or 0.3;
         local v2139 = u696.fmode3 or 0.2;
         local v2140 = u669[u670];
         local v2141;
         if (v2140 == 3) then
            v2141 = v2139;
            if (not v2141) then
               v2136 = true;
            end
         else
            v2136 = true;
         end
         if (v2136) then
            local v2142 = false;
            local v2143 = u669[u670];
            if (v2143 == 2) then
               v2141 = v2138;
               if (not v2141) then
                  v2142 = true;
               end
            else
               v2142 = true;
            end
            if (v2142) then
               v2141 = v2137;
            end
         end
         u677 = v2141;
      end;
      local u697 = v2026;
      local f_updatefiremodestability = f_updatefiremodestability;
      local u698 = v2134;
      local u699 = v2028;
      local u700 = v2089;
      local u701 = v2033;
      local u702 = v2059;
      local u703 = v2035;
      local u704 = v2084;
      local u705 = v2067;
      local f_setequipped;
      f_setequipped = function(p342, p343, p344)
         --[[
            Name: setequipped
            Upvalues: 
               1 => u666
               2 => u438
               3 => u631
               4 => u638
               5 => u636
               6 => u697
               7 => u675
               8 => u669
               9 => u670
               10 => u673
               11 => u671
               12 => f_updatefiremodestability
               13 => u390
               14 => u639
               15 => u682
               16 => u676
               17 => u640
               18 => u388
               19 => u641
               20 => u635
               21 => u634
               22 => u698
               23 => u627
               24 => u699
               25 => u642
               26 => u700
               27 => u701
               28 => t_CurrentCamera_287
               29 => u702
               30 => u386
               31 => u681
               32 => u703
               33 => u704
               34 => u684
               35 => u685
               36 => u643
               37 => u391
               38 => u705
               39 => u665
               40 => u644
               41 => u645
               42 => u392
               43 => u667
   
         --]]
         if (p344) then
            p342:hide();
         end
         if (not (p343 and (not (u666 and u438)))) then
            if ((not p343) and u666) then
               local g_next_305 = next;
               local v2144, v2145 = u705:GetChildren();
               local v2146 = v2144;
               local v2147 = v2145;
               while true do
                  local v2148, v2149 = g_next_305(v2146, v2147);
                  local v2150 = v2148;
                  local v2151 = v2149;
                  if (v2148) then
                     v2147 = v2150;
                     if (v2151:IsA("Sound")) then
                        v2151:Stop();
                     end
                  else
                     break;
                  end
               end
               if (u665) then
                  p342:setaim(false);
               end
               p342.auto = false;
               if (not u697.burstcam) then
                  p342.burst = 0;
               end
               u390 = false;
               u676 = false;
               u642.t = 1;
               u644:applyeffects(u697.effectsettings, false);
               u640:clear();
               u640:add(u645.reset(u703, 0.2, u697.keepanimvisibility));
               local v2152 = u640;
               local u706 = p344;
               v2152:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u635
                        2 => u627
                        3 => u706
                        4 => u699
                        5 => u666
                        6 => u702
                        7 => u392
                        8 => u667
                        9 => u388
   
                  --]]
                  u635:magnify(1);
                  u627:deactivatelasers(u706, u699);
                  u627:destroysights(u706, u699);
                  u666 = false;
                  u702.Part1 = nil;
                  u699.Parent = nil;
                  u392 = false;
                  u667 = false;
                  u388 = nil;
               end);
            end
            return;
         end
         if (not u631.alive) then
            return;
         end
         u638:send("equip", p342.gunnumber);
         u636:setcrosssettings(u697.type, u697.crosssize, u697.crossspeed, u697.crossdamper, u675.sightpart, u675.centermark);
         u636:updatefiremode(u669[u670]);
         u636:updateammo(u673, u671);
         f_updatefiremodestability();
         p342:setaim(false);
         u438 = true;
         u390 = false;
         u639.play("equipCloth", 0.25);
         u682 = false;
         u676 = false;
         u640:clear();
         if (u388) then
            u388:setequipped(false);
         end
         local v2153 = u640;
         local u707 = p342;
         v2153:add(function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u631
                  2 => u697
                  3 => u641
                  4 => u635
                  5 => u636
                  6 => u675
                  7 => u634
                  8 => u698
                  9 => u627
                  10 => u699
                  11 => u642
                  12 => u700
                  13 => u701
                  14 => t_CurrentCamera_287
                  15 => u702
                  16 => u386
                  17 => u666
                  18 => u438
                  19 => u639
                  20 => u681
                  21 => u703
                  22 => u704
                  23 => u684
                  24 => u685
                  25 => u707
                  26 => u643
                  27 => u391
                  28 => u388
   
            --]]
            u631:setbasewalkspeed(u697.walkspeed);
            u641.s = u697.sprintspeed;
            u635.magspring.s = u697.magnifyspeed;
            u635.shakespring.s = u697.camkickspeed;
            u636:setcrosssize(u697.crosssize);
            u635:setswayspeed(u675.swayspeed or 1);
            u635.swayspring.s = u675.steadyspeed or 4;
            u635:setsway(0);
            u634.s = u675.aimspeed;
            u698.s = u675.aimspeed;
            u627:activatelasers(false, u699);
            u642.s = u697.equipspeed or 12;
            u642.t = 0;
            u700.t = 0;
            local v2154 = u701:GetChildren();
            local v2155 = v2154;
            local v2156 = 1;
            local v2157 = #v2154;
            local v2158 = v2157;
            local v2159 = v2156;
            if (not (v2157 <= v2159)) then
               while true do
                  if (v2155[v2156]:IsA("Weld")) then
                     local v2160 = false;
                     if (v2155[v2156].Part1) then
                        local v2161 = v2155[v2156].Part1.Parent;
                        local v2162 = u699;
                        if (v2161 ~= v2162) then
                           v2160 = true;
                        end
                     else
                        v2160 = true;
                     end
                     if (v2160) then
                        v2155[v2156]:Destroy();
                     end
                  end
                  local v2163 = v2156 + 1;
                  v2156 = v2163;
                  local v2164 = v2158;
                  if (v2164 < v2163) then
                     break;
                  end
               end
            end
            if (u699) then
               u699.Parent = t_CurrentCamera_287;
            end
            u702.Part0 = u386;
            u702.Part1 = u701;
            u702.Parent = u701;
            u666 = true;
            u438 = false;
            u639.play("equipCloth", 0.25);
            u639.play("equipGear", 0.1);
            if (u681) then
               u703[u697.bolt].weld.C0 = u704(1);
            end
            local v2165 = false;
            if (u684) then
               v2165 = true;
            else
               local v2166 = u685;
               if (tick() < v2166) then
                  u707:chambergun();
               else
                  v2165 = true;
               end
            end
            if (v2165) then
               u684 = true;
               if (u643.mouse.down.right or u643.controller.down.l2) then
                  u707:setaim(true);
               end
               if (u391) then
                  u641.t = 1;
               end
            end
            u388 = u707;
            u631.grenadehold = false;
         end);
      end;
      v2029.setequipped = f_setequipped;
      local u708 = v2029;
      local f_texturetransparency;
      f_texturetransparency = function(p345, p346)
         --[[
            Name: texturetransparency
            Upvalues: 
               1 => u708
   
         --]]
         local v2167 = p345:GetChildren();
         local v2168 = v2167;
         local v2169 = 1;
         local v2170 = #v2167;
         local v2171 = v2170;
         local v2172 = v2169;
         if (not (v2170 <= v2172)) then
            while true do
               local v2173 = v2168[v2169];
               local v2174 = v2173;
               if (v2173:IsA("Texture") or v2173:IsA("Decal")) then
                  local v2175 = false;
                  local v2176;
                  if (p346 == 1) then
                     v2175 = true;
                  else
                     v2176 = u708.texturedata[p345][v2174].Transparency;
                     if (not v2176) then
                        v2175 = true;
                     end
                  end
                  if (v2175) then
                     v2176 = 1;
                  end
                  v2174.Transparency = v2176;
               else
                  if (v2174:IsA("SurfaceGui")) then
                     v2174.Enabled = p346 ~= 1;
                  end
               end
               local v2177 = v2169 + 1;
               v2169 = v2177;
               local v2178 = v2171;
               if (v2178 < v2177) then
                  break;
               end
            end
         end
      end;
      local u709 = v2090;
      local f_updateaimstatus = f_updateaimstatus;
      local u710 = v2026;
      local f_toggleattachment;
      f_toggleattachment = function(p347)
         --[[
            Name: toggleattachment
            Upvalues: 
               1 => u678
               2 => u709
               3 => f_updateaimstatus
               4 => u684
               5 => u679
               6 => u675
               7 => u710
   
         --]]
         u678 = (u678 % (#u709)) + 1;
         f_updateaimstatus();
         if (((not u684) and u679) and ((not u675.blackscope) and u710.animations.onfire)) then
            p347:chambergun();
         end
      end;
      v2029.toggleattachment = f_toggleattachment;
      local u711 = v2028;
      local u712 = v2026;
      local f_texturetransparency = f_texturetransparency;
      local f_hide;
      f_hide = function(p348, p349)
         --[[
            Name: hide
            Upvalues: 
               1 => u683
               2 => u711
               3 => t_FindFirstChild_288
               4 => u712
               5 => f_texturetransparency
               6 => u675
               7 => u441
               8 => u442
   
         --]]
         if (p349) then
            if (u683) then
               return;
            end
            u683 = true;
            local v2179 = u711:GetChildren();
            local v2180 = v2179;
            local v2181 = 1;
            local v2182 = #v2179;
            local v2183 = v2182;
            local v2184 = v2181;
            if (not (v2182 <= v2184)) then
               while true do
                  local v2185 = v2180[v2181];
                  local v2186 = v2185;
                  if (((t_FindFirstChild_288(v2185, "Mesh") or v2185:IsA("UnionOperation")) or v2185:IsA("MeshPart")) and (not (u712.invisible and u712.invisible[v2185.Name]))) then
                     v2186.Transparency = 1;
                     f_texturetransparency(v2186, 1);
                  end
                  local v2187 = v2181 + 1;
                  v2181 = v2187;
                  local v2188 = v2183;
                  if (v2188 < v2187) then
                     break;
                  end
               end
            end
            f_texturetransparency(u675.sightpart, 1);
            local v2189 = u441:GetChildren();
            local v2190 = v2189;
            local v2191 = 1;
            local v2192 = #v2189;
            local v2193 = v2192;
            local v2194 = v2191;
            if (not (v2192 <= v2194)) then
               while true do
                  local v2195 = v2190[v2191];
                  local v2196 = v2195;
                  if ((t_FindFirstChild_288(v2195, "Mesh") or v2195:IsA("UnionOperation")) or (v2195:IsA("MeshPart") or v2195:IsA("BasePart"))) then
                     v2196.Transparency = 1;
                  end
                  local v2197 = v2191 + 1;
                  v2191 = v2197;
                  local v2198 = v2193;
                  if (v2198 < v2197) then
                     break;
                  end
               end
            end
            local v2199 = u442:GetChildren();
            local v2200 = v2199;
            local v2201 = 1;
            local v2202 = #v2199;
            local v2203 = v2202;
            local v2204 = v2201;
            if (not (v2202 <= v2204)) then
               while true do
                  local v2205 = v2200[v2201];
                  local v2206 = v2205;
                  if ((t_FindFirstChild_288(v2205, "Mesh") or v2205:IsA("UnionOperation")) or (v2205:IsA("MeshPart") or v2205:IsA("BasePart"))) then
                     v2206.Transparency = 1;
                  end
                  local v2207 = v2201 + 1;
                  v2201 = v2207;
                  local v2208 = v2203;
                  if (v2208 < v2207) then
                     break;
                  end
               end
            end
         end
      end;
      v2029.hide = f_hide;
      local f_inspecting;
      f_inspecting = function(p350)
         --[[
            Name: inspecting
            Upvalues: 
               1 => u676
   
         --]]
         return u676;
      end;
      v2029.inspecting = f_inspecting;
      local f_isblackscope;
      f_isblackscope = function(p351)
         --[[
            Name: isblackscope
            Upvalues: 
               1 => u675
   
         --]]
         return u675.blackscope;
      end;
      v2029.isblackscope = f_isblackscope;
      local u713 = v2028;
      local u714 = v2026;
      local f_texturetransparency = f_texturetransparency;
      local u715 = v2090;
      local f_show;
      f_show = function(p352, p353)
         --[[
            Name: show
            Upvalues: 
               1 => u683
               2 => u680
               3 => u713
               4 => t_FindFirstChild_288
               5 => u714
               6 => f_texturetransparency
               7 => u715
               8 => u441
               9 => u442
   
         --]]
         if (not (u683 and (not u680))) then
            return;
         end
         u683 = false;
         local v2209 = u713:GetChildren();
         local v2210 = v2209;
         local v2211 = 1;
         local v2212 = #v2209;
         local v2213 = v2212;
         local v2214 = v2211;
         if (not (v2212 <= v2214)) then
            while true do
               local v2215 = v2210[v2211];
               local v2216 = v2215;
               if (((t_FindFirstChild_288(v2215, "Mesh") or v2215:IsA("UnionOperation")) or (v2215:IsA("MeshPart") or t_FindFirstChild_288(v2215, "Bar"))) and (not (u714.invisible and u714.invisible[v2215.Name]))) then
                  v2216.Transparency = p352.transparencydata[v2216];
                  f_texturetransparency(v2216, 0);
               end
               local v2217 = v2211 + 1;
               v2211 = v2217;
               local v2218 = v2213;
               if (v2218 < v2217) then
                  break;
               end
            end
         end
         local g_next_306 = next;
         local v2219 = u715;
         local v2220 = nil;
         while true do
            local v2221, v2222 = g_next_306(v2219, v2220);
            local v2223 = v2221;
            local v2224 = v2222;
            if (v2221) then
               v2220 = v2223;
               f_texturetransparency(v2224.sightpart, 0);
            else
               break;
            end
         end
         local v2225 = u441:GetChildren();
         local v2226 = v2225;
         local v2227 = 1;
         local v2228 = #v2225;
         local v2229 = v2228;
         local v2230 = v2227;
         if (not (v2228 <= v2230)) then
            while true do
               local v2231 = v2226[v2227];
               local v2232 = v2231;
               if ((t_FindFirstChild_288(v2231, "Mesh") or v2231:IsA("UnionOperation")) or (v2231:IsA("MeshPart") or v2231:IsA("BasePart"))) then
                  v2232.Transparency = 0;
               end
               local v2233 = v2227 + 1;
               v2227 = v2233;
               local v2234 = v2229;
               if (v2234 < v2233) then
                  break;
               end
            end
         end
         local v2235 = u442:GetChildren();
         local v2236 = v2235;
         local v2237 = 1;
         local v2238 = #v2235;
         local v2239 = v2238;
         local v2240 = v2237;
         if (not (v2238 <= v2240)) then
            while true do
               local v2241 = v2236[v2237];
               local v2242 = v2241;
               if ((t_FindFirstChild_288(v2241, "Mesh") or v2241:IsA("UnionOperation")) or (v2241:IsA("MeshPart") or v2241:IsA("BasePart"))) then
                  v2242.Transparency = 0;
               end
               local v2243 = v2237 + 1;
               v2237 = v2243;
               local v2244 = v2239;
               if (v2244 < v2243) then
                  break;
               end
            end
         end
      end;
      v2029.show = f_show;
      local u716 = v2026;
      local f_updatescope;
      f_updatescope = function(p354)
         --[[
            Name: updatescope
            Upvalues: 
               1 => u680
               2 => u679
               3 => u636
               4 => u675
               5 => u644
               6 => u716
   
         --]]
         if (not (u680 and (not u679))) then
            if ((not u680) and u679) then
               u679 = false;
               p354:show();
               u636:setscope(false);
               u644:applyeffects(u716.effectsettings, false);
            end
            return;
         end
         u679 = true;
         p354:hide(true);
         u636:setscope(true, u675.nosway);
         u644:applyeffects(u716.effectsettings, true);
      end;
      v2029.updatescope = f_updatescope;
      local f_isaiming;
      f_isaiming = function()
         --[[
            Name: isaiming
            Upvalues: 
               1 => u665
   
         --]]
         return u665;
      end;
      v2029.isaiming = f_isaiming;
      local u717 = v2026;
      local u718 = v2134;
      local f_updateaimstatus = f_updateaimstatus;
      local u719 = v2030;
      local u720 = v2089;
      local u721 = v2035;
      local f_setaim;
      f_setaim = function(p355, p356)
         --[[
            Name: setaim
            Upvalues: 
               1 => u390
               2 => u666
               3 => u717
               4 => u682
               5 => u638
               6 => u665
               7 => u391
               8 => u641
               9 => u399
               10 => u675
               11 => u635
               12 => u636
               13 => u639
               14 => u634
               15 => u646
               16 => u667
               17 => u718
               18 => f_updateaimstatus
               19 => u719
               20 => u647
               21 => u673
               22 => u671
               23 => u684
               24 => u392
               25 => u720
               26 => u640
               27 => u645
               28 => u721
               29 => u643
               30 => u631
               31 => t_FindFirstChild_288
               32 => u648
               33 => f_updatewalkspeed
   
         --]]
         if (not (((not u390) and u666) and (not u717.forcehip))) then
            return;
         end
         if (p356 and (not (u682 and (not u717.straightpull)))) then
            u638:send("aim", true);
            u665 = true;
            u391 = false;
            u641.t = 0;
            u638:send("sprint", u391);
            u399 = u675.aimwalkspeedmult;
            u635.shakespring.s = u675.aimcamkickspeed;
            u635:setaimsensitivity(true);
            u636:setcrosssize(0);
            u639.play("aimGear", 0.15);
            u634.t = 1;
            local v2245 = u646;
            local v2246;
            if ((u667 and u675.zoompullout) and u675.aimspringcancel) then
               v2246 = 0;
            else
               if ((u667 and u675.zoompullout) and (not u675.blackscope)) then
                  v2246 = 0.5;
               else
                  v2246 = 1;
               end
            end
            v2245.t = v2246;
            local v2247 = u718;
            local v2248;
            if (u667 and u675.zoompullout) then
               v2248 = 0;
            else
               v2248 = 1;
            end
            v2247.t = v2248;
            f_updateaimstatus();
         else
            if (not p356) then
               if (u665 and u675.blackscope) then
                  u719:clear();
               end
               u647.setsprintdisable(false);
               u665 = false;
               u639.play("aimCloth", 0.15);
               u638:send("aim", false);
               u636:setcrosssize(u717.crosssize);
               u635.shakespring.s = u717.camkickspeed;
               u399 = 1;
               u635:setaimsensitivity(false);
               u634.t = 0;
               u646.t = 0;
               u718.t = 0;
               f_updateaimstatus();
               local v2249 = u719;
               local u722 = p355;
               v2249:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u665
                        2 => u673
                        3 => u671
                        4 => u390
                        5 => u722
   
                  --]]
                  if (not u665) then
                     local v2250 = u673;
                     if (v2250 == 0) then
                        local v2251 = u671;
                        if ((v2251 > 0) and (not u390)) then
                           u722:reload();
                        end
                     end
                  end
               end);
               local v2252 = u673;
               if (((v2252 > 0) and (not u684)) and (((not u682) and u717.animations.onfire) and u675.pullout)) then
                  u392 = true;
                  u667 = true;
                  u682 = true;
                  u720.t = 1;
                  u640:add(u645.player(u721, u717.animations.onfire));
                  local v2253 = u640;
                  local u723 = p355;
                  v2253:add(function()
                     --[[
                        Name: (empty)
                        Upvalues: 
                           1 => u684
                           2 => u640
                           3 => u645
                           4 => u721
                           5 => u717
                           6 => u665
                           7 => u392
                           8 => u667
                           9 => u682
                           10 => u720
                           11 => u391
                           12 => u641
                           13 => u643
                           14 => u723
   
                     --]]
                     u684 = true;
                     local v2254 = u640;
                     local t_reset_307 = u645.reset;
                     local v2255 = u721;
                     local t_resettime_308 = u717.animations.onfire.resettime;
                     local v2256 = u717.keepanimvisibility;
                     if (not v2256) then
                        v2256 = u665;
                     end
                     v2254:add(t_reset_307(v2255, t_resettime_308, v2256));
                     u640:add(function()
                        --[[
                           Name: (empty)
                           Upvalues: 
                              1 => u392
                              2 => u667
                              3 => u682
                              4 => u720
                              5 => u391
                              6 => u641
                              7 => u643
                              8 => u723
   
                        --]]
                        u392 = false;
                        u667 = false;
                        u682 = false;
                        u720.t = 0;
                        if (u391) then
                           u641.t = 1;
                        end
                        if (u643.mouse.down.right or u643.controller.down.l2) then
                           u723:setaim(true);
                        end
                     end);
                  end);
               end
               if (not u675.blackscope) then
                  local v2257 = u631;
                  local v2258 = u643.keyboard.down.leftshift;
                  if (not v2258) then
                     v2258 = u643.keyboard.down.w;
                     if (v2258) then
                        v2258 = t_FindFirstChild_288(u648, "Doubletap");
                     end
                  end
                  v2257:setsprint(v2258);
               end
            end
         end
         f_updatewalkspeed();
      end;
      v2029.setaim = f_setaim;
      local u724 = v2026;
      local u725 = v2035;
      local f_chambergun;
      f_chambergun = function(p357)
         --[[
            Name: chambergun
            Upvalues: 
               1 => u673
               2 => u724
               3 => u390
               4 => u667
               5 => u391
               6 => u641
               7 => u640
               8 => u645
               9 => u725
               10 => u684
               11 => u665
               12 => u392
               13 => u643
   
         --]]
         print("pretend to chamber gun");
         local v2259 = u673;
         if (not ((v2259 > 0) and u724.animations.pullbolt)) then
            u684 = true;
            return;
         end
         u390 = true;
         u667 = true;
         if (u391) then
            u641.t = 0;
         end
         u640:add(u645.player(u725, u724.animations.pullbolt));
         local v2260 = u640;
         local u726 = p357;
         v2260:add(function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u684
                  2 => u640
                  3 => u645
                  4 => u725
                  5 => u724
                  6 => u665
                  7 => u392
                  8 => u667
                  9 => u390
                  10 => u391
                  11 => u641
                  12 => u643
                  13 => u726
   
            --]]
            u684 = true;
            local v2261 = u640;
            local t_reset_309 = u645.reset;
            local v2262 = u725;
            local t_resettime_310 = u724.animations.pullbolt.resettime;
            local v2263 = u724.keepanimvisibility;
            if (not v2263) then
               v2263 = u665;
            end
            v2261:add(t_reset_309(v2262, t_resettime_310, v2263));
            u640:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u392
                     2 => u667
                     3 => u390
                     4 => u391
                     5 => u641
                     6 => u643
                     7 => u726
   
               --]]
               u392 = false;
               u667 = false;
               u390 = false;
               if (u391) then
                  u641.t = 1;
               end
               if (u643.mouse.down.right or u643.controller.down.l2) then
                  u726:setaim(true);
               end
            end);
         end);
      end;
      v2029.chambergun = f_chambergun;
      local u727 = v2035;
      local u728 = v2026;
      local u729 = v2089;
      local f_playanimation;
      f_playanimation = function(p358, p359)
         --[[
            Name: playanimation
            Upvalues: 
               1 => u390
               2 => u438
               3 => u667
               4 => u640
               5 => u392
               6 => u645
               7 => u727
               8 => u728
               9 => u665
               10 => u641
               11 => u676
               12 => u729
               13 => u680
               14 => u643
               15 => u391
   
         --]]
         if ((u390 or u438) or u667) then
            return;
         end
         u640:clear();
         if (u392) then
            u640:add(u645.reset(u727, 0.05, u728.keepanimvisibility));
         end
         if (u665 and (not (p359 == "selector"))) then
            p358:setaim(false);
         end
         u392 = true;
         u641.t = 0;
         local v2264 = {};
         if (p359 == "inspect") then
            u676 = true;
         end
         u729.t = 1;
         u640:add(u645.player(u727, u728.animations[p359]));
         local v2265 = u640;
         local u730 = p359;
         local u731 = p358;
         v2265:add(function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u640
                  2 => u645
                  3 => u727
                  4 => u728
                  5 => u730
                  6 => u680
                  7 => u676
                  8 => u392
                  9 => u390
                  10 => u643
                  11 => u665
                  12 => u731
                  13 => u391
                  14 => u641
                  15 => u729
   
            --]]
            local v2266 = u640;
            local t_reset_311 = u645.reset;
            local v2267 = u727;
            local t_resettime_312 = u728.animations[u730].resettime;
            local v2268 = u728.keepanimvisibility;
            if (not v2268) then
               v2268 = u680;
            end
            v2266:add(t_reset_311(v2267, t_resettime_312, v2268));
            u640:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u676
                     2 => u392
                     3 => u390
                     4 => u643
                     5 => u665
                     6 => u731
                     7 => u391
                     8 => u641
                     9 => u729
   
               --]]
               u676 = false;
               u392 = false;
               if (u390) then
                  return;
               end
               if ((u643.mouse.down.right or u643.controller.down.l2) and (not u665)) then
                  u731:setaim(true);
               end
               if (u391) then
                  u641.t = 1;
               end
               u729.t = 0;
            end);
         end);
      end;
      v2029.playanimation = f_playanimation;
      local u732 = v2033;
      local f_dropguninfo;
      f_dropguninfo = function(p360)
         --[[
            Name: dropguninfo
            Upvalues: 
               1 => u673
               2 => u671
               3 => u732
   
         --]]
         return u673, u671, u732.Position;
      end;
      v2029.dropguninfo = f_dropguninfo;
      local f_addammo;
      f_addammo = function(p361, p362, p363)
         --[[
            Name: addammo
            Upvalues: 
               1 => u671
               2 => u636
               3 => u673
               4 => u649
   
         --]]
         u671 = u671 + p362;
         u636:updateammo(u673, u671);
         u649:customaward("Picked up " .. (p362 .. (" rounds from dropped " .. p363)));
      end;
      v2029.addammo = f_addammo;
      local u733 = v2035;
      local u734 = v2026;
      local u735 = v2089;
      local f_reloadcancel;
      f_reloadcancel = function(p364, p365)
         --[[
            Name: reloadcancel
            Upvalues: 
               1 => u390
               2 => u640
               3 => u645
               4 => u733
               5 => u734
               6 => u392
               7 => u676
               8 => u735
               9 => u684
               10 => u643
               11 => u391
               12 => u641
   
         --]]
         if (u390 or p365) then
            u640:clear();
            u640:add(u645.reset(u733, 0.2, u734.keepanimvisibility));
            u390 = false;
            u392 = false;
            u676 = false;
            u735.t = 0;
            if (u684) then
               if (u643.mouse.down.right or u643.controller.down.l2) then
                  p364:setaim(true);
               end
               if (u391) then
                  u641.t = 1;
               end
            else
               p364:chambergun();
               return;
            end
         end
      end;
      v2029.reloadcancel = f_reloadcancel;
      local u736 = t_chamber_291;
      local u737 = v2030;
      local u738 = v2035;
      local u739 = v2026;
      local u740 = v2089;
      local f_reload;
      f_reload = function(p366)
         --[[
            Name: reload
            Upvalues: 
               1 => u667
               2 => u438
               3 => u390
               4 => u671
               5 => u673
               6 => u736
               7 => u672
               8 => u392
               9 => u640
               10 => u737
               11 => u645
               12 => u738
               13 => u739
               14 => u665
               15 => u676
               16 => u641
               17 => u740
               18 => u684
               19 => u638
               20 => u636
               21 => u681
               22 => u391
               23 => u643
   
         --]]
         if (not ((u667 or u438) or u390)) then
            local v2269 = u671;
            if (v2269 > 0) then
               local v2270 = false;
               local v2271 = u673;
               local v2272;
               if (u736) then
                  v2272 = u672 + 1;
                  if (not v2272) then
                     v2270 = true;
                  end
               else
                  v2270 = true;
               end
               if (v2270) then
                  v2272 = u672;
               end
               if (v2271 ~= v2272) then
                  local u741 = nil;
                  if (u392) then
                     u640:clear();
                     u737:clear();
                     u640:add(u645.reset(u738, 0.1, u739.keepanimvisibility));
                  end
                  if (u665) then
                     p366:setaim(false);
                  end
                  u676 = false;
                  u392 = true;
                  u390 = true;
                  u641.t = 0;
                  p366.auto = false;
                  p366.burst = 0;
                  u740.t = 1;
                  local t_type_313 = u739.type;
                  if (t_type_313 == "SHOTGUN") then
                     local v2273 = not u739.magfeed;
                     if (v2273 == true) then
                        local v2274 = u671;
                        u741 = true;
                        u640:add(u645.player(u738, u739.animations.tacticalreload));
                        u640:add(function()
                           --[[
                              Name: (empty)
                              Upvalues: 
                                 1 => u673
                                 2 => u671
                                 3 => u684
                                 4 => u638
                                 5 => u636
   
                           --]]
                           u673 = u673 + 1;
                           u671 = u671 - 1;
                           u684 = true;
                           u638:send("reload");
                           u636:updateammo(u673, u671);
                        end);
                        local v2275 = v2274 - 1;
                        local v2276 = u673;
                        local v2277 = u672;
                        if (v2276 < v2277) then
                           local v2278 = u671;
                           if ((v2278 > 0) and (v2275 > 0)) then
                              local v2279 = 2;
                              local v2280 = u672 - u673;
                              local v2281 = v2280;
                              local v2282 = v2279;
                              if (not (v2280 <= v2282)) then
                                 while true do
                                    local v2283 = u671;
                                    if ((v2283 > 0) and (v2275 > 0)) then
                                       local v2284 = false;
                                       v2275 = v2275 - 1;
                                       local v2285;
                                       if (u739.altreload) then
                                          v2285 = u739.animations[u739.altreload .. "reload"];
                                          if (not v2285) then
                                             v2284 = true;
                                          end
                                       else
                                          v2284 = true;
                                       end
                                       if (v2284) then
                                          v2285 = u739.animations.reload;
                                       end
                                       u640:add(u645.player(u738, v2285));
                                       u640:add(function()
                                          --[[
                                             Name: (empty)
                                             Upvalues: 
                                                1 => u673
                                                2 => u671
                                                3 => u638
                                                4 => u636
   
                                          --]]
                                          u673 = u673 + 1;
                                          u671 = u671 - 1;
                                          u638:send("reload");
                                          u636:updateammo(u673, u671);
                                       end);
                                    end
                                    local v2286 = v2279 + 1;
                                    v2279 = v2286;
                                    local v2287 = v2281;
                                    if (v2287 < v2286) then
                                       break;
                                    end
                                 end
                              end
                           end
                        end
                        local v2288 = u673;
                        if (v2288 == 0) then
                           u640:add(u645.player(u738, u739.animations.pump));
                        end
                        local v2289 = u640;
                        local u742 = p366;
                        v2289:add(function()
                           --[[
                              Name: (empty)
                              Upvalues: 
                                 1 => u640
                                 2 => u645
                                 3 => u738
                                 4 => u741
                                 5 => u739
                                 6 => u740
                                 7 => u390
                                 8 => u392
                                 9 => u676
                                 10 => u681
                                 11 => u684
                                 12 => u391
                                 13 => u641
                                 14 => u643
                                 15 => u742
   
                           --]]
                           local v2290 = false;
                           local v2291 = u640;
                           local t_reset_315 = u645.reset;
                           local v2292 = u738;
                           local v2293;
                           if (u741 and u739.animations.tacticalreload.resettime) then
                              v2293 = u739.animations.tacticalreload.resettime;
                              if (not v2293) then
                                 v2290 = true;
                              end
                           else
                              v2290 = true;
                           end
                           if (v2290) then
                              local v2294 = false;
                              if ((not u741) and u739.animations.reload.resettime) then
                                 v2293 = u739.animations.reload.resettime;
                                 if (not v2293) then
                                    v2294 = true;
                                 end
                              else
                                 v2294 = true;
                              end
                              if (v2294) then
                                 v2293 = 0.5;
                              end
                           end
                           v2291:add(t_reset_315(v2292, v2293), u739.keepanimvisibility);
                           u640:add(function()
                              --[[
                                 Name: (empty)
                                 Upvalues: 
                                    1 => u740
                                    2 => u390
                                    3 => u392
                                    4 => u676
                                    5 => u681
                                    6 => u684
                                    7 => u391
                                    8 => u641
                                    9 => u643
                                    10 => u742
   
                              --]]
                              u740.t = 0;
                              u390 = false;
                              u392 = false;
                              u676 = false;
                              u681 = false;
                              u684 = true;
                              if (u391) then
                                 u641.t = 1;
                              end
                              if (u643.mouse.down.right or u643.controller.down.l2) then
                                 u742:setaim(true);
                              end
                           end);
                        end);
                     end
                  end
                  if (u739.animations.uniquereload) then
                     local u743 = u673 == 0;
                     if (u739.animations.initstage) then
                        u640:add(u645.player(u738, u739.animations.initstage));
                     else
                        if (u743) then
                           u743 = true;
                           if (u739.animations.initemptystage) then
                              u640:add(u645.player(u738, u739.animations.initemptystage));
                           end
                        end
                     end
                     local v2295 = u671;
                     local v2296 = u673;
                     local v2297 = u672;
                     if (v2296 < v2297) then
                        local v2298 = u671;
                        if ((v2298 > 0) and (v2295 > 0)) then
                           local v2299 = 1;
                           local v2300 = u672 - u673;
                           local v2301 = v2300;
                           local v2302 = v2299;
                           if (not (v2300 <= v2302)) then
                              while true do
                                 local v2303 = u671;
                                 if ((v2303 > 0) and (v2295 > 0)) then
                                    v2295 = v2295 - 1;
                                    if (u739.animations.reloadstage) then
                                       u640:add(u645.player(u738, u739.animations.reloadstage));
                                    end
                                    u640:add(function()
                                       --[[
                                          Name: (empty)
                                          Upvalues: 
                                             1 => u673
                                             2 => u671
                                             3 => u638
                                             4 => u636
   
                                       --]]
                                       u673 = u673 + 1;
                                       u671 = u671 - 1;
                                       u638:send("reload");
                                       u636:updateammo(u673, u671);
                                    end);
                                 end
                                 local v2304 = v2299 + 1;
                                 v2299 = v2304;
                                 local v2305 = v2301;
                                 if (v2305 < v2304) then
                                    break;
                                 end
                              end
                           end
                        end
                     end
                     if (u743) then
                        print("empty relaod");
                        if (u739.animations.emptyendstage) then
                           u640:add(u645.player(u738, u739.animations.emptyendstage));
                        end
                     else
                        if (u739.animations.endstage) then
                           u640:add(u645.player(u738, u739.animations.endstage));
                        end
                     end
                     local v2306 = u640;
                     local u744 = p366;
                     v2306:add(function()
                        --[[
                           Name: (empty)
                           Upvalues: 
                              1 => u640
                              2 => u645
                              3 => u738
                              4 => u743
                              5 => u739
                              6 => u740
                              7 => u390
                              8 => u392
                              9 => u676
                              10 => u681
                              11 => u684
                              12 => u391
                              13 => u641
                              14 => u643
                              15 => u744
   
                        --]]
                        local v2307 = false;
                        local v2308 = u640;
                        local t_reset_314 = u645.reset;
                        local v2309 = u738;
                        local v2310;
                        if (u743 and u739.animations.emptyendstage.resettime) then
                           v2310 = u739.animations.emptyendsstage.resettime;
                           if (not v2310) then
                              v2307 = true;
                           end
                        else
                           v2307 = true;
                        end
                        if (v2307) then
                           local v2311 = false;
                           if ((not u743) and u739.animations.endstage.resettime) then
                              v2310 = u739.animations.endstage.resettime;
                              if (not v2310) then
                                 v2311 = true;
                              end
                           else
                              v2311 = true;
                           end
                           if (v2311) then
                              v2310 = 0.5;
                           end
                        end
                        v2308:add(t_reset_314(v2309, v2310), u739.keepanimvisibility);
                        u640:add(function()
                           --[[
                              Name: (empty)
                              Upvalues: 
                                 1 => u740
                                 2 => u390
                                 3 => u392
                                 4 => u676
                                 5 => u681
                                 6 => u684
                                 7 => u391
                                 8 => u641
                                 9 => u643
                                 10 => u744
   
                           --]]
                           u740.t = 0;
                           u390 = false;
                           u392 = false;
                           u676 = false;
                           u681 = false;
                           u684 = true;
                           if (u391) then
                              u641.t = 1;
                           end
                           if (u643.mouse.down.right or u643.controller.down.l2) then
                              u744:setaim(true);
                           end
                        end);
                     end);
                  else
                     local v2312 = u673;
                     local u745;
                     if (v2312 == 0) then
                        local v2313 = false;
                        local v2314;
                        if (u739.altreloadlong) then
                           v2314 = u739.animations[u739.altreloadlong .. "reload"];
                           if (not v2314) then
                              v2313 = true;
                           end
                        else
                           v2313 = true;
                        end
                        if (v2313) then
                           v2314 = u739.animations.reload;
                        end
                        u745 = v2314;
                     else
                        local v2315 = false;
                        local v2316;
                        if (u739.altreload) then
                           v2316 = u739.animations[u739.altreload .. "tacticalreload"];
                           if (not v2316) then
                              v2315 = true;
                           end
                        else
                           v2315 = true;
                        end
                        if (v2315) then
                           v2316 = u739.animations.tacticalreload;
                        end
                        u745 = v2316;
                        u741 = true;
                     end
                     u640:add(u645.player(u738, u745));
                     local v2317 = u640;
                     local u746 = p366;
                     v2317:add(function()
                        --[[
                           Name: (empty)
                           Upvalues: 
                              1 => u671
                              2 => u673
                              3 => u736
                              4 => u672
                              5 => u681
                              6 => u638
                              7 => u636
                              8 => u640
                              9 => u645
                              10 => u738
                              11 => u745
                              12 => u739
                              13 => u740
                              14 => u390
                              15 => u392
                              16 => u676
                              17 => u684
                              18 => u391
                              19 => u641
                              20 => u643
                              21 => u746
   
                        --]]
                        local v2318 = false;
                        u671 = u671 + u673;
                        local v2319 = u673;
                        local v2320;
                        if ((not (v2319 == 0)) and u736) then
                           v2318 = true;
                        else
                           v2320 = u672;
                           if (not v2320) then
                              v2318 = true;
                           end
                        end
                        if (v2318) then
                           v2320 = u672 + 1;
                        end
                        local v2321 = false;
                        local v2322;
                        if (u671 < v2320) then
                           v2322 = u671;
                           if (not v2322) then
                              v2321 = true;
                           end
                        else
                           v2321 = true;
                        end
                        if (v2321) then
                           v2322 = v2320;
                        end
                        u673 = v2322;
                        u671 = u671 - u673;
                        u681 = false;
                        u638:send("reload");
                        u636:updateammo(u673, u671);
                        u640:add(u645.reset(u738, u745.resettime or 0.5, u739.keepanimvisibility));
                        u640:add(function()
                           --[[
                              Name: (empty)
                              Upvalues: 
                                 1 => u740
                                 2 => u390
                                 3 => u392
                                 4 => u676
                                 5 => u684
                                 6 => u391
                                 7 => u641
                                 8 => u643
                                 9 => u746
   
                           --]]
                           u740.t = 0;
                           u390 = false;
                           u392 = false;
                           u676 = false;
                           u684 = true;
                           if (u391) then
                              u641.t = 1;
                           end
                           if (u643.mouse.down.right or u643.controller.down.l2) then
                              u746:setaim(true);
                           end
                        end);
                     end);
                  end
               end
            end
         end
      end;
      v2029.reload = f_reload;
      local u747 = v2090;
      local f_memes;
      f_memes = function(p367)
         --[[
            Name: memes
            Upvalues: 
               1 => u672
               2 => u673
               3 => u671
               4 => u668
               5 => u669
               6 => u747
   
         --]]
         u672 = 2 * u672;
         u673 = u672;
         u671 = 1000000;
         u668 = 1000;
         u669 = {
            true,
            1,
            2,
            3
         };
         local v2323 = 1;
         local v2324 = #u747;
         local v2325 = v2324;
         local v2326 = v2323;
         if (not (v2324 <= v2326)) then
            while true do
               local v2327 = u747[v2323];
               v2327.firerate = u668;
               v2327.variablefirerate = nil;
               local v2328 = v2323 + 1;
               v2323 = v2328;
               local v2329 = v2325;
               if (v2329 < v2328) then
                  break;
               end
            end
         end
      end;
      v2029.memes = f_memes;
      local u748 = v2026;
      local f_shoot;
      f_shoot = function(p368, p369)
         --[[
            Name: shoot
            Upvalues: 
               1 => u650
               2 => u673
               3 => u684
               4 => u390
               5 => u438
               6 => u669
               7 => u670
               8 => u631
               9 => u674
               10 => u748
               11 => u686
   
         --]]
         if (p369) then
            if (u650.lock) then
               return;
            end
            local v2330 = u673;
            if (v2330 == 0) then
               p368:reload();
            end
            if (u684) then
               if (u390) then
                  local v2331 = u673;
                  if (v2331 > 0) then
                     p368:reloadcancel();
                     return;
                  end
               end
               if (not (u390 or u438)) then
                  local v2332 = u669[u670];
                  local v2333 = tick();
                  u631:setsprint(false);
                  if (v2332 == true) then
                     p368.auto = true;
                  else
                     local t_burst_316 = p368.burst;
                     if ((t_burst_316 == 0) and (u674 < v2333)) then
                        p368.burst = v2332;
                     end
                  end
                  if (u748.burstcam) then
                     p368.auto = true;
                  end
                  if (u674 < v2333) then
                     u674 = v2333;
                     return;
                  end
               end
            else
               return;
            end
         else
            if (not u748.loosefiring) then
               local v2334 = tick();
               if (u748.autoburst and p368.auto) then
                  local v2335 = u686;
                  if (v2335 > 0) then
                     u674 = v2334 + (60 / u748.firecap);
                  end
               end
               u686 = 0;
               p368.auto = false;
               if (not (u748.burstlock or u748.burstcam)) then
                  p368.burst = 0;
               end
            end
         end
      end;
      v2029.shoot = f_shoot;
      local u749 = v2026;
      local u750 = v2035;
      local u751 = v2134;
      local f_updateaimstatus = f_updateaimstatus;
      local f_updatefiremodestability = f_updatefiremodestability;
      local f_nextfiremode;
      f_nextfiremode = function(p370)
         --[[
            Name: nextfiremode
            Upvalues: 
               1 => u390
               2 => u675
               3 => u749
               4 => u392
               5 => u640
               6 => u645
               7 => u750
               8 => u665
               9 => u646
               10 => u751
               11 => f_updateaimstatus
               12 => u391
               13 => u641
               14 => u667
               15 => u680
               16 => u676
               17 => u670
               18 => u669
               19 => u636
               20 => u668
               21 => f_updatefiremodestability
   
         --]]
         if (u390) then
            return;
         end
         local v2336 = u675.zoom;
         if (u749.animations.selector) then
            if (u392) then
               u640:clear();
               u640:add(u645.reset(u750, 0.2, u749.keepanimvisibility));
            end
            u392 = true;
            if (u665 and (not u675.aimspringcancel)) then
               u646.t = 0.5;
               u751.t = 0;
               f_updateaimstatus();
            end
            if (u391) then
               u641.t = 0.5;
            end
            u667 = true;
            u640:add(u645.player(u750, u749.animations.selector));
            u640:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u640
                     2 => u645
                     3 => u750
                     4 => u749
                     5 => u680
                     6 => u392
                     7 => u676
                     8 => u667
                     9 => u391
                     10 => u641
                     11 => u665
                     12 => u646
                     13 => u751
                     14 => f_updateaimstatus
   
               --]]
               local v2337 = u640;
               local t_reset_317 = u645.reset;
               local v2338 = u750;
               local t_resettime_318 = u749.animations.selector.resettime;
               local v2339 = u749.keepanimvisibility;
               if (not v2339) then
                  v2339 = u680;
               end
               v2337:add(t_reset_317(v2338, t_resettime_318, v2339));
               u392 = false;
               u676 = false;
               u667 = false;
               if (u391) then
                  u641.t = 1;
               end
               if (u665) then
                  u646.t = 1;
                  u751.t = 1;
                  f_updateaimstatus();
               end
            end);
         end
         local v2340 = u640;
         local u752 = p370;
         v2340:add(function()
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u670
                  2 => u669
                  3 => u636
                  4 => u675
                  5 => u668
                  6 => u752
                  7 => f_updatefiremodestability
   
            --]]
            u670 = (u670 % (#u669)) + 1;
            u636:updatefiremode(u669[u670]);
            if (u675.variablefirerate) then
               u668 = u675.firerate[u670];
            end
            if (u752.auto) then
               u752.auto = false;
            end
            f_updatefiremodestability();
            return u669[u670];
         end);
      end;
      v2029.nextfiremode = f_nextfiremode;
      local u753 = v2026;
      local u754 = v2035;
      local u755 = v2084;
      local f_boltkick;
      f_boltkick = function(p371)
         --[[
            Name: boltkick
            Upvalues: 
               1 => u753
               2 => u681
               3 => u754
               4 => u755
   
         --]]
         p371 = (p371 / u753.bolttime) * 1.5;
         u681 = false;
         if (p371 > 1.5) then
            u754[u753.bolt].weld.C0 = u755(0);
            return nil;
         end
         if (not (p371 > 0.5)) then
            u754[u753.bolt].weld.C0 = u755(1 - ((4 * (p371 - 0.5)) * (p371 - 0.5)));
            return false;
         end
         p371 = ((p371 - 0.5) * 0.5) + 0.5;
         u754[u753.bolt].weld.C0 = u755(1 - ((4 * (p371 - 0.5)) * (p371 - 0.5)));
         return false;
      end;
      local u756 = v2026;
      local u757 = v2035;
      local u758 = v2084;
      local f_boltstop;
      f_boltstop = function(p372)
         --[[
            Name: boltstop
            Upvalues: 
               1 => u756
               2 => u757
               3 => u758
               4 => u681
   
         --]]
         p372 = (p372 / u756.bolttime) * 1.5;
         if (p372 > 0.5) then
            u757[u756.bolt].weld.C0 = u758(1);
            u681 = true;
            return true;
         end
         u757[u756.bolt].weld.C0 = u758(1 - ((4 * (p372 - 0.5)) * (p372 - 0.5)));
         u681 = false;
         return false;
      end;
      local u759 = t_range0_292;
      local u760 = t_damage0_294;
      local u761 = t_range1_293;
      local u762 = t_damage1_295;
      local u763 = v2026;
      local f_playerhitdection;
      f_playerhitdection = function(p373, p374, p375, p376, p377, p378)
         --[[
            Name: playerhitdection
            Upvalues: 
               1 => u631
               2 => u651
               3 => u759
               4 => u760
               5 => u761
               6 => u762
               7 => u763
               8 => u636
               9 => u644
               10 => u639
               11 => u638
   
         --]]
         if (u631.alive) then
            if (p375.Parent) then
               local v2341 = p374.TeamColor;
               local t_TeamColor_319 = u651.TeamColor;
               if (v2341 ~= t_TeamColor_319) then
                  local v2342 = false;
                  local v2343 = (p373.origin - p376).Magnitude;
                  local t_Magnitude_320 = v2343;
                  local v2344 = u759;
                  local v2345;
                  if (v2343 < v2344) then
                     v2345 = u760;
                     if (not v2345) then
                        v2342 = true;
                     end
                  else
                     v2342 = true;
                  end
                  if (v2342) then
                     local v2346 = false;
                     local v2347 = u761;
                     if (t_Magnitude_320 < v2347) then
                        v2345 = (((u762 - u760) / (u761 - u759)) * (t_Magnitude_320 - u759)) + u760;
                        if (not v2345) then
                           v2346 = true;
                        end
                     else
                        v2346 = true;
                     end
                     if (v2346) then
                        v2345 = u762;
                     end
                  end
                  local v2348 = false;
                  local t_Name_321 = p375.Name;
                  local v2349;
                  if (t_Name_321 == "Head") then
                     v2349 = v2345 * u763.multhead;
                     if (not v2349) then
                        v2348 = true;
                     end
                  else
                     v2348 = true;
                  end
                  if (v2348) then
                     local v2350 = false;
                     local t_Name_322 = p375.Name;
                     if (t_Name_322 == "Torso") then
                        v2349 = v2345 * u763.multtorso;
                        if (not v2349) then
                           v2350 = true;
                        end
                     else
                        v2350 = true;
                     end
                     if (v2350) then
                        v2349 = v2345;
                     end
                  end
                  local v2351 = v2349;
                  u636:firehitmarker(p375.Name == "Head");
                  u644:bloodhit(p376, true, v2351, p373.velocity / 10);
                  u639.PlaySound("hitmarker", nil, 1, 1.5);
                  if (p378) then
                     table.insert(p378, {
                        p374,
                        p376,
                        p375,
                        p377
                     });
                     return;
                  end
                  u638:send("bullethit", p374, p376, p375, p377);
                  return;
               end
            else
               warn(string.format("We hit a bodypart that doesn't exist %s %s", u651.Name, p375.Name));
            end
         end
      end;
      local f_hitdetection;
      f_hitdetection = function(p379, p380, p381, p382, p383, p384, p385, p386, p387)
         --[[
            Name: hitdetection
            Upvalues: 
               1 => u644
               2 => u637
               3 => u636
   
         --]]
         local t_Name_323 = p380.Parent.Name;
         if (t_Name_323 == "Dead") then
            u644:bloodhit(p381);
            return;
         end
         if (p380.Anchored) then
            local t_Name_324 = p380.Name;
            if (t_Name_324 == "Window") then
               u644:breakwindow(p380, p381, p382, p379.velocity, u637(), p387, p385, p386);
            end
            local t_Name_325 = p380.Name;
            if (t_Name_325 == "Hitmark") then
               u636:firehitmarker();
            else
               local t_Name_326 = p380.Name;
               if (t_Name_326 == "HitmarkHead") then
                  u636:firehitmarker(true);
               end
            end
            u644:bullethit(p380, p381, p382, p383, p384, p379.velocity, true, true, math.random(0, 2));
         end
      end;
      local g_next_327 = next;
      local v2352 = nil;
      while true do
         local v2353, v2354 = g_next_327(v2090, v2352);
         local v2355 = v2353;
         local v2356 = v2354;
         if (v2353) then
            v2352 = v2355;
            if (v2356.reddot) then
               v2356.sightpart.Transparency = 1;
               u627:addreddot(v2356.sightpart);
            else
               if (v2356.midscope) then
                  u627:addscope(v2356);
               else
                  if (v2356.blackscope) then
                     u627:addscope(v2356);
                  end
               end
            end
         else
            break;
         end
      end
      local u764 = v2028;
      local f_attachmenteffect;
      f_attachmenteffect = function()
         --[[
            Name: attachmenteffect
            Upvalues: 
               1 => u627
               2 => u764
               3 => u636
               4 => u634
               5 => u675
   
         --]]
         if (u627.sighttable) then
            local v2357 = false;
            u627.sighteffect(true, u764, u636);
            local v2358 = u636;
            local t_p_328 = u634.p;
            local v2359;
            if (t_p_328 > 0.5) then
               v2359 = u627.activedot;
               if (not v2359) then
                  v2359 = u627.activescope;
                  if (not v2359) then
                     v2357 = true;
                  end
               end
            else
               v2357 = true;
            end
            if (v2357) then
               v2359 = u675.sightpart;
            end
            v2358:updatesightmark(v2359, u675.centermark);
            u636:updatescopemark(u627.activescope);
         end
         if (u627.lasertable) then
            u627.lasereffect();
         end
      end;
      local u765 = v2026;
      local u766 = v2029;
      local f_readytofire;
      f_readytofire = function()
         --[[
            Name: readytofire
            Upvalues: 
               1 => u674
               2 => u666
               3 => u650
               4 => u765
               5 => u766
   
         --]]
         local v2360 = tick();
         local v2361 = u674;
         if (not (((not (v2360 < v2361)) and u666) and (not u650.lock))) then
            return false;
         end
         if (u765.burstcam) then
            local v2362 = u766.auto;
            if (v2362) then
               v2362 = 0 < u766.burst;
            end
            return v2362;
         end
         local v2363 = u766.auto;
         if (not v2363) then
            v2363 = 0 < u766.burst;
         end
         return v2363;
      end;
      local f_readytofire = f_readytofire;
      local u767 = v2029;
      local u768 = v2030;
      local u769 = v2026;
      local u770 = v2135;
      local f_updateaimstatus = f_updateaimstatus;
      local u771 = v2089;
      local u772 = v2035;
      local u773 = v2033;
      local f_boltstop = f_boltstop;
      local f_boltkick = f_boltkick;
      local u774 = v2087;
      local u775 = v2085;
      local u776 = v2086;
      local u777 = v2067;
      local f_playerhitdection = f_playerhitdection;
      local f_hitdetection = f_hitdetection;
      local u778 = t_hideflash_296;
      local u779 = v2028;
      local u780;
      u780 = function(p388)
         --[[
            Name: (empty)
            Upvalues: 
               1 => u673
               2 => f_readytofire
               3 => u676
               4 => u767
               5 => u768
               6 => u769
               7 => u684
               8 => u685
               9 => u665
               10 => u675
               11 => u770
               12 => u646
               13 => f_updateaimstatus
               14 => u392
               15 => u667
               16 => u682
               17 => u771
               18 => u640
               19 => u645
               20 => u772
               21 => u643
               22 => u391
               23 => u641
               24 => u644
               25 => u773
               26 => f_boltstop
               27 => f_boltkick
               28 => u636
               29 => u652
               30 => u774
               31 => u393
               32 => u637
               33 => u775
               34 => u677
               35 => f_pickv3
               36 => u776
               37 => u635
               38 => u639
               39 => u777
               40 => u653
               41 => u651
               42 => u624
               43 => u654
               44 => u655
               45 => u656
               46 => u657
               47 => u633
               48 => f_playerhitdection
               49 => u658
               50 => u659
               51 => u674
               52 => f_hitdetection
               53 => u638
               54 => f_bfgsounds
               55 => u778
               56 => u686
               57 => u671
               58 => u669
               59 => u670
               60 => u668
               61 => u779
   
         --]]
         local v2364 = tick();
         while true do
            local v2365 = u673;
            if ((v2365 > 0) and f_readytofire()) then
               if (u676) then
                  u767:reloadcancel(true);
                  u676 = false;
               end
               u768:clear();
               if (u769.requirechamber) then
                  u684 = false;
                  u685 = v2364 + (u769.chambercooldown or 2);
               end
               local v2366 = false;
               if (u769.forceonfire) then
                  v2366 = true;
               else
                  local v2367 = u673;
                  if (((v2367 > 1) and u769.animations.onfire) and (not (u665 and (not (u665 and (not (u675.pullout and (not u769.straightpull)))))))) then
                     v2366 = true;
                  else
                     if (u769.shelloffset) then
                        if (not u769.caselessammo) then
                           local v2368 = u644;
                           local t_CFrame_341 = u773.CFrame;
                           local v2369 = u769.casetype;
                           if (not v2369) then
                              v2369 = u769.ammotype;
                           end
                           v2368:ejectshell(t_CFrame_341, v2369, u769.shelloffset);
                        end
                        local v2370 = u673;
                        if (v2370 > 0) then
                           local v2371 = false;
                           local v2372 = u768;
                           local v2373 = u673;
                           local v2374;
                           if ((v2373 == 1) and u769.boltlock) then
                              v2374 = f_boltstop;
                              if (not v2374) then
                                 v2371 = true;
                              end
                           else
                              v2371 = true;
                           end
                           if (v2371) then
                              v2374 = f_boltkick;
                           end
                           v2372:add(v2374);
                        end
                     end
                  end
               end
               if (v2366) then
                  local v2375 = u675.zoom;
                  if (u675.zoompullout) then
                     u770.t = 0;
                     local v2376 = u646;
                     local v2377;
                     if ((u665 and (not u769.aimspringcancel)) and (not u769.straightpull)) then
                        v2377 = 0.5;
                     else
                        v2377 = 1;
                     end
                     v2376.t = v2377;
                     f_updateaimstatus();
                  end
                  u392 = true;
                  u667 = true;
                  local u781;
                  if (u675.onfireanim) then
                     u781 = u769.animations["onfire" .. u675.onfireanim];
                  else
                     u781 = u769.animations.onfire;
                  end
                  u682 = true;
                  if (not u769.ignorestanceanim) then
                     u771.t = 1;
                  end
                  u640:clear();
                  u640:add(u645.player(u772, u781));
                  u640:add(function()
                     --[[
                        Name: (empty)
                        Upvalues: 
                           1 => u640
                           2 => u645
                           3 => u772
                           4 => u781
                           5 => u769
                           6 => u665
                           7 => u646
                           8 => u770
                           9 => f_updateaimstatus
                           10 => u682
                           11 => u667
                           12 => u684
                           13 => u392
                           14 => u771
                           15 => u643
                           16 => u767
                           17 => u391
                           18 => u641
                           19 => u673
   
                     --]]
                     local v2378 = u640;
                     local t_reset_329 = u645.reset;
                     local v2379 = u772;
                     local t_resettime_330 = u781.resettime;
                     local v2380 = u769.keepanimvisibility;
                     if (not v2380) then
                        v2380 = u665;
                     end
                     v2378:add(t_reset_329(v2379, t_resettime_330, v2380));
                     if (u665) then
                        u646.t = 1;
                        u770.t = 1;
                        f_updateaimstatus();
                     end
                     u682 = false;
                     u667 = false;
                     u684 = true;
                     u392 = false;
                     u771.t = 0;
                     if (u643.mouse.down.right or u643.controller.down.l2) then
                        u767:setaim(true);
                     end
                     if (u391) then
                        u641.t = 1;
                     end
                     if (u769.forcereload) then
                        local v2381 = u673;
                        if ((v2381 == 0) and (not u665)) then
                           u767:reload();
                        end
                     end
                  end);
               end
               if (not u665) then
                  u636.crossspring.a = u769.crossexpansion * (1 - p388);
               end
               local t_burst_331 = u767.burst;
               if (t_burst_331 ~= 0) then
                  u767.burst = u767.burst - 1;
               end
               local v2382;
               if (u652.purecontroller()) then
                  v2382 = 0.5;
               else
                  v2382 = 1;
               end
               if (u769.firedelay) then
                  local g_delay_340 = delay;
                  local v2383 = u769.firedelay or 0;
                  local u782 = p388;
                  local u783 = v2382;
                  g_delay_340(v2383, function()
                     --[[
                        Name: (empty)
                        Upvalues: 
                           1 => u774
                           2 => u636
                           3 => u769
                           4 => u393
                           5 => u782
                           6 => u637
                           7 => u775
                           8 => u677
                           9 => f_pickv3
                           10 => u675
                           11 => u776
                           12 => u635
                           13 => u783
   
                     --]]
                     u774.a = ((((((u636.crossspring.p / u769.crosssize) * 0.5) * (1 - u393)) * (1 - u782)) * u769.hipfirespread) * u769.hipfirespreadrecover) * u637((2 * math.random()) - 1, (2 * math.random()) - 1, 0);
                     u775.a = ((1 - u677) * (1 - u393)) * (((1 - u782) * f_pickv3(u769.transkickmin, u769.transkickmax)) + (u782 * f_pickv3(u675.aimtranskickmin, u675.aimtranskickmax)));
                     u776.a = ((1 - u677) * (1 - u393)) * (((1 - u782) * f_pickv3(u769.rotkickmin, u769.rotkickmax)) + (u782 * f_pickv3(u675.aimrotkickmin, u675.aimrotkickmax)));
                     u635:shake(((((1 - u677) * (1 - u782)) * u783) * f_pickv3(u769.camkickmin, u769.camkickmax)) + ((((1 - u677) * u783) * u782) * f_pickv3(u675.aimcamkickmin, u675.aimcamkickmax)));
                  end);
               else
                  u774.a = ((((((u636.crossspring.p / u769.crosssize) * 0.5) * (1 - u393)) * (1 - p388)) * u769.hipfirespread) * u769.hipfirespreadrecover) * u637((2 * math.random()) - 1, (2 * math.random()) - 1, 0);
                  u775.a = ((1 - u677) * (1 - u393)) * (((1 - p388) * f_pickv3(u769.transkickmin, u769.transkickmax)) + (((1 - u677) * p388) * f_pickv3(u675.aimtranskickmin, u675.aimtranskickmax)));
                  u776.a = ((1 - u677) * (1 - u393)) * (((1 - p388) * f_pickv3(u769.rotkickmin, u769.rotkickmax)) + (((1 - u677) * p388) * f_pickv3(u675.aimrotkickmin, u675.aimrotkickmax)));
                  u635:shake(((((1 - u677) * (1 - p388)) * v2382) * f_pickv3(u769.camkickmin, u769.camkickmax)) + ((((1 - u677) * p388) * v2382) * f_pickv3(u675.aimcamkickmin, u675.aimcamkickmax)));
               end
               delay(0.4, function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u769
                        2 => u639
   
                  --]]
                  local t_type_332 = u769.type;
                  if (t_type_332 == "SNIPER") then
                     u639.play("metalshell", 0.15, 0.8);
                     return;
                  end
                  local t_type_333 = u769.type;
                  if (t_type_333 == "SHOTGUN") then
                     wait(0.3);
                     u639.play("shotgunshell", 0.2);
                     return;
                  end
                  local t_type_334 = u769.type;
                  if (not ((t_type_334 == "REVOLVER") or u769.caselessammo)) then
                     u639.play("metalshell", 0.1);
                  end
               end);
               local v2384 = u769.bulletcolor;
               if (not v2384) then
                  v2384 = Color3.new(0.7843137254901961, 0.2745098039215687, 0.2745098039215687);
               end
               local v2385 = false;
               local v2386 = {
                  workspace.Players,
                  workspace.Terrain,
                  workspace.Ignore,
                  u635.currentcamera
               };
               local v2387 = {};
               local u784 = {};
               local v2388;
               if (u665) then
                  v2388 = u675.sightpart;
                  if (not v2388) then
                     v2385 = true;
                  end
               else
                  v2385 = true;
               end
               if (v2385) then
                  v2388 = u777;
               end
               local v2389 = false;
               local v2390 = v2388.CFrame;
               local t_CFrame_335 = v2390;
               local v2391 = u635.basecframe.p;
               local v2392, v2393, v2394 = workspace:FindPartOnRayWithIgnoreList(u653(v2391, v2390.p - v2391), {
                  workspace.Players:FindFirstChild(u651.Team.Name),
                  workspace.Terrain,
                  workspace.Ignore,
                  u635.currentcamera
               });
               local u785 = v2393 + (0.01 * v2394);
               local v2395 = {};
               v2395.camerapos = u635.basecframe.p;
               v2395.firepos = u785;
               v2395.bullets = v2387;
               local v2396 = 1;
               local t_type_336 = u769.type;
               local v2397;
               if (t_type_336 == "SHOTGUN") then
                  v2397 = u769.pelletcount;
                  if (not v2397) then
                     v2389 = true;
                  end
               else
                  v2389 = true;
               end
               if (v2389) then
                  v2397 = 1;
               end
               local v2398 = v2396;
               local v2399 = v2397;
               if (not (v2399 <= v2398)) then
                  while true do
                     local v2400 = false;
                     u624 = u624 + 1;
                     local v2401 = u624;
                     local v2402 = {};
                     local u786 = t_CFrame_335.lookVector * u769.bulletspeed;
                     local v2403 = nil;
                     if (u769.choke) then
                        local v2404 = math.random(0, 2 * u654);
                        local v2405 = u769.crosssize * ((u769.aimchoke * p388) + (u769.hipchoke * (1 - p388)));
                        local v2406;
                        if (u769.spreadpattern) then
                           v2406 = u769.spreadpattern[v2396];
                        else
                           local v2407 = (((2 * u654) * (v2396 - 1)) / (u769.pelletcount - 1)) + v2404;
                           local v2408 = u655(v2407);
                           local v2409 = u656(v2407);
                           local t_pelletcount_339 = u769.pelletcount;
                           if (t_pelletcount_339 > 8) then
                              local v2410 = v2396 % 2;
                              local v2411;
                              if (v2410 == 0) then
                                 v2411 = 0.5;
                              else
                                 v2411 = 1;
                              end
                              v2405 = v2405 * v2411;
                           end
                           v2406 = u637(v2408, v2409, 0);
                        end
                        v2403 = t_CFrame_335:VectorToWorldSpace(v2406 * v2405);
                        v2400 = true;
                     else
                        local t_type_338 = u769.type;
                        if (t_type_338 == "SHOTGUN") then
                           if (v2396 > 1) then
                              local v2412 = false;
                              local v2413;
                              if (u769.hipchoke) then
                                 v2413 = u657.random(u769.crosssize * u769.hipchoke);
                                 if (not v2413) then
                                    v2412 = true;
                                 end
                              else
                                 v2412 = true;
                              end
                              if (v2412) then
                                 v2413 = u633;
                              end
                              v2403 = v2413;
                              v2400 = true;
                           else
                              v2400 = true;
                           end
                        else
                           local v2414 = false;
                           local v2415;
                           if (u769.aimchoke) then
                              v2415 = u657.random(u769.crosssize * ((u769.aimchoke * p388) + (u769.hipchoke * (1 - p388))));
                              if (not v2415) then
                                 v2414 = true;
                              end
                           else
                              v2414 = true;
                           end
                           if (v2414) then
                              v2415 = u633;
                           end
                           v2403 = v2415;
                           v2400 = true;
                        end
                     end
                     if (v2400) then
                        if (v2403) then
                           u786 = u786 + v2403;
                        end
                        v2387[(#v2387) + 1] = {
                           u786,
                           v2401
                        };
                        local u787 = v2402;
                        local u788 = v2401;
                        local f_onplayerhit;
                        f_onplayerhit = function(p389, p390, p391, p392)
                           --[[
                              Name: onplayerhit
                              Upvalues: 
                                 1 => u787
                                 2 => f_playerhitdection
                                 3 => u788
                                 4 => u784
   
                           --]]
                           if (u787[p390]) then
                              return;
                           end
                           u787[p390] = true;
                           f_playerhitdection(p389, p390, p391, p392, u788, u784);
                        end;
                        local v2416 = u658.new;
                        local v2417 = {};
                        v2417.position = u785;
                        v2417.velocity = u786;
                        v2417.acceleration = u659.bulletAcceleration;
                        v2417.color = v2384;
                        v2417.size = 0.2;
                        v2417.bloom = 0.005;
                        v2417.brightness = 400;
                        v2417.life = u659.bulletLifeTime;
                        v2417.visualorigin = u777.Position;
                        v2417.physicsignore = v2386;
                        v2417.dt = v2364 - u674;
                        v2417.penetrationdepth = u769.penetrationdepth;
                        v2417.wallbang = nil;
                        v2417.onplayerhit = f_onplayerhit;
                        local u789 = v2364;
                        v2417.ontouch = function(p393, p394, p395, p396, p397, p398, p399)
                           --[[
                              Name: (empty)
                              Upvalues: 
                                 1 => f_hitdetection
                                 2 => u785
                                 3 => u786
                                 4 => u789
   
                           --]]
                           f_hitdetection(p393, p394, p395, p396, p397, p398, u785, u786, u789);
                        end;
                        v2416(v2417);
                        local v2418 = v2396 + 1;
                        v2396 = v2418;
                        local v2419 = v2397;
                        if (v2419 < v2418) then
                           break;
                        end
                     end
                  end
               end
               u638:send("newbullets", v2395, v2364);
               local v2420 = #u784;
               if (v2420 > 0) then
                  local v2421 = 1;
                  local v2422 = #u784;
                  local v2423 = v2422;
                  local v2424 = v2421;
                  if (not (v2422 <= v2424)) then
                     while true do
                        u638:send("bullethit", unpack(u784[v2421]));
                        local v2425 = v2421 + 1;
                        v2421 = v2425;
                        local v2426 = v2423;
                        if (v2426 < v2425) then
                           break;
                        end
                     end
                  end
               end
               u784 = nil;
               u639.PlaySoundId(u769.firesoundid, u769.firevolume, u769.firepitch, u777, nil, 0, 0.05);
               if (u769.sniperbass) then
                  f_bfgsounds();
               end
               if ((not u769.nomuzzleeffects) and u644.enablemuzzleeffects) then
                  u644:muzzleflash(u777, u778);
               end
               if (not u769.hideminimap) then
                  u636:goingloud();
               end
               local v2427 = false;
               u673 = u673 - 1;
               u686 = u686 + 1;
               u636:updateammo(u673, u671);
               if ((u767.burst <= 0) and u769.firecap) then
                  local v2428 = u669[u670];
                  if (v2428 == true) then
                     v2427 = true;
                  else
                     u674 = v2364 + (60 / u769.firecap);
                  end
               else
                  v2427 = true;
               end
               if (v2427) then
                  local v2429 = false;
                  if (u769.autoburst and u767.auto) then
                     local v2430 = u686;
                     local t_autoburst_337 = u769.autoburst;
                     if (v2430 < t_autoburst_337) then
                        u674 = u674 + (60 / u769.burstfirerate);
                     else
                        v2429 = true;
                     end
                  else
                     v2429 = true;
                  end
                  if (v2429) then
                     if (u665 and u675.aimedfirerate) then
                        u674 = u674 + (60 / u675.aimedfirerate);
                     else
                        u674 = u674 + (60 / u668);
                     end
                  end
               end
               local v2431 = u673;
               if (v2431 == 0) then
                  u767.burst = 0;
                  u767.auto = false;
                  if (u769.magdisappear) then
                     u779[u769.mag].Transparency = 1;
                  end
                  if (not ((u675.pullout or u675.blackscope) and u665)) then
                     local v2432 = u669[1];
                     if (not ((not (v2432 == true)) and u665)) then
                        u767:reload();
                     end
                  end
               end
            else
               break;
            end
         end
      end;
      local u790 = v2135;
      local u791 = v2090;
      local u792 = v2035;
      local u793 = v2029;
      local u794 = v2072;
      local u795 = v2026;
      local u796 = t_mainoffset_290;
      local u797 = v2078;
      local u798 = v2083;
      local u799 = v2089;
      local u800 = v2081;
      local u801 = v2075;
      local u802 = v2087;
      local u803 = v2085;
      local u804 = v2086;
      local u805 = t_mainpart_289;
      local u806 = v2059;
      local u807 = v2030;
      local f_attachmenteffect = f_attachmenteffect;
      local f_step;
      f_step = function(p400)
         --[[
            Name: step
            Upvalues: 
               1 => u646
               2 => u634
               3 => u790
               4 => u635
               5 => u660
               6 => u401
               7 => u641
               8 => u680
               9 => u633
               10 => u791
               11 => u792
               12 => u630
               13 => u793
               14 => u636
               15 => u675
               16 => u643
               17 => u647
               18 => u661
               19 => u794
               20 => u795
               21 => u665
               22 => u631
               23 => u386
               24 => u796
               25 => u797
               26 => u662
               27 => u663
               28 => f_gunbob
               29 => f_gunsway
               30 => u798
               31 => u629
               32 => u799
               33 => u800
               34 => u801
               35 => u642
               36 => u802
               37 => u803
               38 => u804
               39 => u805
               40 => u806
               41 => u440
               42 => u439
               43 => u807
               44 => u664
               45 => f_attachmenteffect
               46 => u780
   
         --]]
         local t_p_342 = u646.p;
         local v2433 = u634.p;
         local t_p_343 = v2433;
         local t_p_344 = u790.p;
         u635.controllermult = ((1 - v2433) * 0.6) + (v2433 * 0.4);
         local v2434 = (u660.p / u401.p) * u641.p;
         local v2435;
         if (v2434 > 1) then
            v2435 = 1;
         else
            v2435 = v2434;
         end
         local v2436 = v2435;
         u680 = false;
         local v2437 = 0;
         local v2438 = u633;
         local v2439 = u633;
         local v2440 = u633;
         local v2441 = u633;
         local v2442 = u633;
         local v2443 = u633;
         local v2444 = 1;
         local v2445 = #u791;
         local v2446 = v2445;
         local v2447 = v2444;
         if (not (v2445 <= v2447)) then
            while true do
               local v2448 = u791[v2444];
               local v2449 = v2448;
               local v2450 = v2448.sightspring.p;
               local t_p_348 = v2450;
               v2438 = v2438 + (v2450 * v2448.aimoffsetp);
               v2439 = v2439 + (v2450 * v2448.aimoffsetr);
               v2440 = v2440 + (v2450 * v2448.larmaimoffsetp);
               v2441 = v2441 + (v2450 * v2448.larmaimoffsetr);
               v2442 = v2442 + (v2450 * v2448.rarmaimoffsetp);
               v2443 = v2443 + (v2450 * v2448.rarmaimoffsetr);
               v2437 = v2437 + v2450;
               if (v2448.blackscope and (v2449.scopebegin < t_p_348)) then
                  u680 = true;
               end
               local v2451 = v2444 + 1;
               v2444 = v2451;
               local v2452 = v2446;
               if (v2452 < v2451) then
                  break;
               end
            end
         end
         local v2453 = u792.larm.weld.C0;
         local t_C0_345 = v2453;
         local v2454 = v2453.p;
         local v2455 = u630.toaxisangle(v2453);
         local v2456 = u792.rarm.weld.C0;
         local t_C0_346 = v2456;
         local v2457 = v2456.p;
         local v2458 = u630.toaxisangle(v2456);
         local v2459 = v2440 + ((1 - v2437) * v2454);
         local v2460 = v2441 + ((1 - v2437) * v2455);
         local v2461 = v2442 + ((1 - v2437) * v2457);
         local v2462 = v2443 + ((1 - v2437) * v2458);
         u793:updatescope();
         local v2463 = u636:getsteadysize();
         if (u680) then
            u635:setsway(u675.swayamp or 0);
            if (u675.breathspeed) then
               if ((v2463 < 1) and ((u643.keyboard.down.leftshift or u643.controller.down.up) or (u643.controller.down.l3 or u647.steadytoggle))) then
                  local v2464 = false;
                  u635:setswayspeed(0);
                  local v2465 = u636;
                  local v2466 = u661;
                  local v2467;
                  if (v2463 < 1) then
                     v2467 = v2463 + ((p400 * 60) * u675.breathspeed);
                     if (not v2467) then
                        v2464 = true;
                     end
                  else
                     v2464 = true;
                  end
                  if (v2464) then
                     v2467 = v2463;
                  end
                  v2465:setsteadybar(v2466(v2467, 0, 1, 0));
               else
                  local v2468 = false;
                  u647.steadytoggle = false;
                  u635:setswayspeed(u675.swayspeed or 1);
                  local v2469 = u636;
                  local v2470 = u661;
                  local v2471;
                  if (v2463 > 0) then
                     v2471 = v2463 - ((p400 * 60) * u675.recoverspeed);
                     if (not v2471) then
                        v2468 = true;
                     end
                  else
                     v2468 = true;
                  end
                  if (v2468) then
                     v2471 = 0;
                  end
                  v2469:setsteadybar(v2470(v2471, 0, 1, 0));
               end
            end
         else
            local v2472 = false;
            u635:setswayspeed(0);
            local v2473 = u636;
            local v2474 = u661;
            local v2475;
            if (v2463 > 0) then
               v2475 = v2463 - ((p400 * 60) * (u675.recoverspeed or 0.005));
               if (not v2475) then
                  v2472 = true;
               end
            else
               v2472 = true;
            end
            if (v2472) then
               v2475 = 0;
            end
            v2473:setsteadybar(v2474(v2475, 0, 1, 0));
         end
         local v2476 = false;
         local v2477 = u794(v2438 * t_p_342) * u630.fromaxisangle(v2439 * t_p_342);
         local v2478 = u794(v2459) * u630.fromaxisangle(v2460);
         local v2479 = u794(v2461) * u630.fromaxisangle(v2462);
         local v2480;
         if (u675.blackscope) then
            v2480 = math.max(0.2, 1 - t_p_343);
            if (not v2480) then
               v2476 = true;
            end
         else
            v2476 = true;
         end
         if (v2476) then
            local v2481 = false;
            if (u795.midscope) then
               v2480 = math.max(0.4, 1 - t_p_343);
               if (not v2480) then
                  v2481 = true;
               end
            else
               v2481 = true;
            end
            if (v2481) then
               v2480 = math.max(0.6, 1 - t_p_343);
            end
         end
         local v2482 = false;
         local v2483;
         if (u665) then
            v2483 = u795.aimswingmod;
            if (not v2483) then
               v2482 = true;
            end
         else
            v2482 = true;
         end
         if (v2482) then
            v2483 = u795.swingmod;
            if (not v2483) then
               v2483 = 1;
            end
         end
         local v2484 = ((((((((((((((((u386.CFrame:inverse() * u635.shakecframe) * u796) * u797(u662.p)) * u794(v2477.p)) * u794(0, 0, 1)) * u630.fromaxisangle(u663.v * (v2480 * v2483))) * u794(0, 0, -1)) * f_gunbob(0.7 - (0.3 * t_p_343), 1 - (0.8 * t_p_343))) * f_gunsway(t_p_343)) * u630.interpolate(u798(u631.pronespring.p * (1 - t_p_343)), u629, u799.p)) * u630.interpolate(u630.interpolate(u800(u631.crouchspring.p), u629, u799.p), u629, t_p_343)) * u630.interpolate(u801(v2436), u795.equipoffset, u642.p)) * u630.fromaxisangle(u802.p)) * u794(u803.p)) * u630.fromaxisangle(u804.p)) * (v2477 - v2477.p)) * u792[u805].weld.C0;
         u806.C0 = v2484;
         u440.C0 = v2484 * u630.interpolate(u630.interpolate(t_C0_345, v2478, t_p_344), u795.larmsprintoffset, v2436);
         u439.C0 = v2484 * u630.interpolate(u630.interpolate(t_C0_346, v2479, t_p_344), u795.rarmsprintoffset, v2436);
         u807:step();
         if (not u664:isdeployed()) then
            u793:setequipped(false);
         end
         local t_t_347 = u662.t;
         if ((t_t_347 == 1) and u665) then
            u793:setaim(false);
         end
         f_attachmenteffect();
         u780(t_p_343);
      end;
      v2029.step = f_step;
      return v2029;
   end;
   v5.loadgun = f_loadgun;
   if (v3) then
      local v2485 = v33.keyboard.onkeydown;
      local u808 = v13;
      v2485:connect(function(p401)
         --[[
            Name: (empty)
            Upvalues: 
               1 => u808
   
         --]]
         if (p401 == "k") then
            u808.gammo = 9999999;
         end
         if ((p401 == "l") and u808.currentgun) then
            u808.currentgun:memes();
         end
      end);
   end
   v5.healwait = 8;
   v5.healrate = 0.25;
   v5.maxhealth = 100;
   v5.ondied = v26.new();
   local u809 = 0;
   local u810 = 0;
   local u811 = false;
   local u812 = v5;
   local f_gethealth;
   f_gethealth = function()
      --[[
         Name: gethealth
         Upvalues: 
            1 => u812
            2 => u811
            3 => u810
            4 => u809
   
      --]]
      local t_healrate_350 = u812.healrate;
      local t_maxhealth_351 = u812.maxhealth;
      if (not u811) then
         return 0;
      end
      local v2486 = tick() - u810;
      local v2487 = v2486;
      if (v2486 < 0) then
         return u809;
      end
      local v2488 = false;
      local v2489 = u809 + ((v2487 * v2487) * t_healrate_350);
      local v2490 = v2489;
      local v2491;
      if (v2489 < t_maxhealth_351) then
         v2491 = v2490;
         if (not v2491) then
            v2488 = true;
         end
      else
         v2488 = true;
      end
      if (v2488) then
         v2491 = t_maxhealth_351;
      end
      return v2491, true;
   end;
   v5.gethealth = f_gethealth;
   local v2492 = v5.ondied;
   local u813 = v5;
   v2492:connect(function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => u813
   
      --]]
      u813.alive = false;
   end);
   local u814 = v1380;
   local u815 = v5;
   local u816 = v18;
   local f_spawn;
   f_spawn = function(p402, p403)
      --[[
         Name: spawn
         Upvalues: 
            1 => u814
            2 => u815
            3 => u816
   
      --]]
      u814.t = 0;
      u815.deadcf = nil;
      u815.grenadehold = false;
      u815:reloadsprings();
      u816:send("spawn", p403);
   end;
   v5.spawn = f_spawn;
   local u817 = v5;
   local u818 = v18;
   local f_despawn;
   f_despawn = function(p404)
      --[[
         Name: despawn
         Upvalues: 
            1 => u817
            2 => u818
            3 => u388
   
      --]]
      if (u817.alive) then
         u818:send("forcereset");
         if (u388) then
            u388:setequipped(false);
         end
      end
   end;
   v5.despawn = f_despawn;
   local u819 = v5;
   local u820 = v30;
   v18:add("despawn", function(p405)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u819
            2 => u820
   
      --]]
      u819.ondied:fire(p405);
      u820.currentcamera:ClearAllChildren();
   end);
   local u821 = v5;
   v18:add("updatepersonalhealth", function(p406, p407, p408, p409, p410)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u811
            2 => u809
            3 => u810
            4 => u821
   
      --]]
      u811 = p410;
      u809 = p406;
      u810 = p407;
      u821.healrate = p408;
      u821.maxhealth = p409;
   end);
   local v2493 = {};
   local v2494 = shared.require("physics");
   local v2495 = v2494.trajectory;
   v2494.trajectory = nil;
   local v2496 = v38.getscale;
   local v2497 = game:GetService("Players").LocalPlayer.PlayerGui.MainGui;
   local u822 = v2493;
   local f_stoptracker;
   f_stoptracker = function()
      --[[
         Name: stoptracker
         Upvalues: 
            1 => u822
   
      --]]
      local v2498 = 1;
      local v2499 = #u822;
      local v2500 = v2499;
      local v2501 = v2498;
      if (not (v2499 <= v2501)) then
         while true do
            u822[v2498].BackgroundTransparency = 1;
            local v2502 = v2498 + 1;
            v2498 = v2502;
            local v2503 = v2500;
            if (v2503 < v2502) then
               break;
            end
         end
      end
   end;
   local u823 = v21;
   local u824 = v30;
   local t_MainGui_352 = v2497;
   local t_getscale_353 = v2496;
   local u825 = v2493;
   local u826 = v7;
   local u827 = v10;
   local u828 = v1367;
   local u829 = v12;
   local t_trajectory_354 = v2495;
   local u830 = v14;
   local f_tracker;
   f_tracker = function(p411)
      --[[
         Name: tracker
         Upvalues: 
            1 => u823
            2 => u824
            3 => t_MainGui_352
            4 => t_getscale_353
            5 => u825
            6 => u826
            7 => u827
            8 => u828
            9 => u829
            10 => t_trajectory_354
            11 => u830
   
      --]]
      local v2504 = game:GetService("Players"):GetPlayers();
      local v2505 = v2504;
      local v2506 = u823.anglesyx(u824.angles.x, u824.angles.y);
      local v2507 = 0.004629629629629629 * t_MainGui_352.AbsoluteSize.y;
      local v2508 = 0.995;
      local v2509 = nil;
      local v2510 = nil;
      local v2511 = t_getscale_353();
      local g_next_355 = next;
      local v2512 = v2504;
      local v2513 = nil;
      while true do
         local v2514, v2515 = g_next_355(v2512, v2513);
         local v2516 = v2514;
         local v2517 = v2515;
         if (v2514) then
            v2513 = v2516;
            if (not u825[v2516]) then
               local v2518 = Instance.new("Frame");
               v2518.Rotation = 45;
               v2518.BorderSizePixel = 0;
               v2518.SizeConstraint = "RelativeYY";
               v2518.BackgroundColor3 = Color3.new(1, 1, 0.7);
               v2518.Size = UDim2.new(0.009259259259259259 * v2511, 0, 0.009259259259259259 * v2511, 0);
               v2518.Parent = t_MainGui_352;
               u825[v2516] = v2518;
            end
            u825[v2516].BackgroundTransparency = 1;
            local v2519 = v2517.TeamColor;
            local t_TeamColor_356 = game:GetService("Players").LocalPlayer.TeamColor;
            if ((not (v2519 == t_TeamColor_356)) and u826:isplayeralive(v2517)) then
               local t_p_357 = u824.cframe.p;
               local v2520, v2521 = u827.getupdater(v2517).getpos();
               local v2522 = v2521;
               if (v2521) then
                  local v2523 = v2522 - t_p_357;
                  local v2524 = v2523.unit:Dot(v2506);
                  if ((v2508 < v2524) and (not workspace:FindPartOnRayWithWhitelist(u828(t_p_357, v2523), u829.raycastwhitelist))) then
                     local v2525 = t_trajectory_354(t_p_357, u830.bulletAcceleration, v2522, p411.bulletspeed);
                     local v2526 = v2525;
                     if (v2525) then
                        v2508 = v2524;
                        v2510 = v2516;
                        v2509 = u824.currentcamera:WorldToViewportPoint(t_p_357 + v2526);
                     end
                  end
               end
            end
         else
            break;
         end
      end
      if (v2510) then
         u825[v2510].BackgroundTransparency = 0;
         u825[v2510].Position = UDim2.new(0, (v2509.x / v2511) - v2507, 0, (v2509.y / v2511) - v2507);
         u825[v2510].Size = UDim2.new(0.009259259259259259 * v2511, 0, 0.009259259259259259 * v2511, 0);
      end
      local v2527 = (#v2505) + 1;
      local v2528 = #u825;
      local v2529 = v2528;
      local v2530 = v2527;
      if (not (v2528 <= v2530)) then
         while true do
            u825[v2527]:Destroy();
            u825[v2527] = nil;
            local v2531 = v2527 + 1;
            v2527 = v2531;
            local v2532 = v2529;
            if (v2532 < v2531) then
               break;
            end
         end
      end
   end;
   local u831 = 0;
   local v2533 = v1360;
   local v2534 = v1358(0, -1.5, 0);
   local v2535 = v1358(0, -1.5, 1.5, 1, 0, 0, 0, 0, 1, 0, -1, 0);
   local u832 = v1390;
   local u833 = v30;
   local u834 = v5;
   local u835 = v2534;
   local u836 = v2535;
   local u837 = v2533;
   local u838 = v1413;
   local u839 = v1364;
   local u840 = v1409;
   local u841 = v23;
   local u842 = v12;
   local u843 = v1362;
   local u844 = v1374;
   local u845 = v1411;
   local u846 = t_soundfonts_208;
   local u847 = v41;
   local u848 = v1418;
   local u849 = v1379;
   local u850 = v11;
   local u851 = v1421;
   local f_step;
   f_step = function(p412)
      --[[
         Name: step
         Upvalues: 
            1 => u832
            2 => u833
            3 => u834
            4 => u397
            5 => u387
            6 => u402
            7 => u835
            8 => u836
            9 => u837
            10 => u811
            11 => u386
            12 => u838
            13 => u839
            14 => u401
            15 => u840
            16 => u841
            17 => u395
            18 => u842
            19 => u843
            20 => u844
            21 => u845
            22 => u831
            23 => u846
            24 => u389
            25 => u847
            26 => u848
            27 => u849
            28 => u850
            29 => u400
            30 => u851
   
      --]]
      local t_p_358 = u832.p;
      local v2536 = 1;
      local v2537 = 1;
      local v2538 = false;
      local v2539 = math.tan((u833.basefov * math.pi) / 360) / math.tan((u834.unaimedfov * math.pi) / 360);
      local v2540 = 1;
      local v2541 = #u397;
      local v2542 = v2541;
      local v2543 = v2540;
      if (not (v2541 <= v2543)) then
         while true do
            local v2544 = u397[v2540].aimsightdata;
            local t_aimsightdata_364 = v2544;
            local v2545 = 1;
            local v2546 = #v2544;
            local v2547 = v2546;
            local v2548 = v2545;
            if (not (v2546 <= v2548)) then
               while true do
                  local v2549 = t_aimsightdata_364[v2545];
                  local v2550 = v2549;
                  local t_p_365 = v2549.sightspring.p;
                  if (v2549.blackscope) then
                     if (v2550.scopebegin < t_p_365) then
                        v2537 = v2550.zoom;
                        v2538 = true;
                     end
                     v2536 = v2536 * ((v2550.prezoom / v2539) ^ t_p_365);
                  else
                     v2536 = v2536 * ((v2550.zoom / v2539) ^ t_p_365);
                  end
                  local v2551 = v2545 + 1;
                  v2545 = v2551;
                  local v2552 = v2547;
                  if (v2552 < v2551) then
                     break;
                  end
               end
            end
            local v2553 = v2540 + 1;
            v2540 = v2553;
            local v2554 = v2542;
            if (v2554 < v2553) then
               break;
            end
         end
      end
      if (v2538) then
         u833:setmagnification(v2537);
      else
         u833:setmagnification(v2539 * (v2536 ^ t_p_358));
      end
      if (u387) then
         local v2555 = u402.p / 1.5;
         local v2556 = v2555;
         if (v2555 < 0) then
            u387.C0 = u835:lerp(u836, -v2556);
         else
            u387.C0 = u835:lerp(u837, v2556);
         end
      end
      if (u811 and u386) then
         local v2557 = u838.v + u839(0, u402.v * 24, 0);
         local v2558 = v2557;
         local v2559 = u401.p;
         local t_p_359 = v2559;
         local v2560 = u833.delta;
         u840.t = u839((((v2557.z / 1024) / 32) - ((v2557.y / 1024) / 16)) - (((v2560.x / 1024) * 3) / 2), ((v2557.x / 1024) / 32) - (((v2560.y / 1024) * 3) / 2), ((v2560.y / 1024) * 3) / 2);
         local v2561 = u841.vtos(u386.CFrame, u386.Velocity);
         local v2562 = v2561;
         local t_magnitude_360 = (u839(1, 0, 1) * v2561).magnitude;
         local v2563 = (0.8 + ((0.2 * (1 - v2561.unit.z)) / 2)) * v2559;
         local v2564 = v2563;
         if (v2563 == v2564) then
            local v2565 = u395;
            local v2566;
            if (u842.lock) then
               v2566 = 0;
            else
               v2566 = v2564;
            end
            v2565.WalkSpeed = v2566;
         end
         u386.CFrame = u843(0, u833.angles.y, 0) + u386.Position;
         local v2567 = u395.FloorMaterial;
         local t_FloorMaterial_361 = v2567;
         local v2568 = u844;
         local v2569;
         if (v2567 == v2568) then
            u845.t = 0;
            v2569 = u845.p;
         else
            u845.t = t_magnitude_360;
            v2569 = u845.p;
            local v2570 = u831;
            local v2571 = ((u834.distance * 3) / 16) - 1;
            if (v2570 < v2571) then
               u831 = u831 + 1;
               local v2572 = u846[t_FloorMaterial_361];
               local v2573 = v2572;
               if (v2572 and (not u389)) then
                  local t_movementmode_363 = u834.movementmode;
                  if (t_movementmode_363 ~= "prone") then
                     local v2574;
                     if (v2569 <= 15) then
                        v2574 = v2573 .. "walk";
                     else
                        v2574 = v2573 .. "run";
                     end
                     local v2575;
                     if ((v2574 == "grasswalk") or (v2574 == "sandwalk")) then
                        v2575 = (v2569 / 40) ^ 2;
                     else
                        v2575 = (v2569 / 35) ^ 2;
                     end
                     local v2576 = false;
                     local v2577;
                     if (v2575 <= 0.75) then
                        v2577 = v2575;
                        if (not v2577) then
                           v2576 = true;
                        end
                     else
                        v2576 = true;
                     end
                     if (v2576) then
                        v2577 = 0.75;
                     end
                     u847.PlaySound("friendly_" .. v2574, "SelfFoley", math.clamp(v2577, 0, 0.5), nil, 0, 0.2);
                     u847.PlaySound("movement_extra", "SelfFoley", math.clamp((v2569 / 50) ^ 2, 0, 0.25));
                     if ((v2569 >= 10) and (v2569 <= 15)) then
                        u847.PlaySound("cloth_walk", "SelfFoley", math.clamp(((v2569 / 20) ^ 2) / 6, 0, 0.25));
                     else
                        if (v2569 > 15) then
                           u847.PlaySound("cloth_run", "SelfFoley", math.clamp(((v2569 / 20) ^ 2) / 3, 0, 0.25));
                        end
                     end
                  end
               end
            end
         end
         local v2578 = false;
         local v2579 = u848;
         local v2580;
         if (t_magnitude_360 < t_p_359) then
            v2580 = t_magnitude_360;
            if (not v2580) then
               v2578 = true;
            end
         else
            v2578 = true;
         end
         if (v2578) then
            v2580 = t_p_359;
         end
         v2579.t = v2580;
         u834.speed = v2569;
         u834.headheight = u402.p;
         u834.distance = u834.distance + (p412 * v2569);
         u838.t = v2562;
         u834.velocity = u838.p;
         u834.acceleration = v2558;
         u834.sprint = u849.p;
         local v2581 = v2562.magnitude;
         local v2582 = (t_p_359 * 1) / 3;
         if (v2581 < v2582) then
            local t_controllertype_362 = u850.controllertype;
            if ((t_controllertype_362 == "controller") and u834.sprinting()) then
               u834:setsprint(false);
            end
         end
      end
      if (u400) then
         u400.Brightness = u851.p;
      end
   end;
   v5.step = f_step;
   local u852 = v5;
   local u853 = v1378;
   local u854 = v1388;
   local f_animstep;
   f_animstep = function(p413)
      --[[
         Name: animstep
         Upvalues: 
            1 => u852
            2 => u853
            3 => u388
            4 => u854
            5 => f_tracker
            6 => f_stoptracker
   
      --]]
      if (u852.alive) then
         u853:step(p413);
         if (u388 and u388.step) then
            u388.step(p413);
            if (u388.attachments) then
               local t_Other_366 = u388.attachments.Other;
               if ((t_Other_366 == "Ballistics Tracker") and u388.isaiming()) then
                  local t_p_367 = u854.p;
                  if (t_p_367 > 0.95) then
                     f_tracker(u388.data);
                     return;
                  end
               end
            end
            f_stoptracker();
            return;
         end
      else
         f_stoptracker();
      end
   end;
   v5.animstep = f_animstep;
   local v2583 = v1364();
   local u855 = t_IsA_198;
   local u856 = v18;
   local u857 = t_LocalPlayer_204;
   local f_dealwithit;
   f_dealwithit = function(p414)
      --[[
         Name: dealwithit
         Upvalues: 
            1 => u855
            2 => u856
            3 => u857
   
      --]]
      if (u855(p414, "Script")) then
         p414.Disabled = true;
         return;
      end
      if (u855(p414, "BodyMover")) then
         local t_Name_368 = p414.Name;
         if (t_Name_368 ~= "\n") then
            u856:send("logmessage", "BodyMover");
            u857:Kick();
            return;
         end
      end
      if (u855(p414, "BasePart")) then
         p414.Transparency = 1;
         p414.CollisionGroupId = 1;
         p414.CanCollide = true;
      end
   end;
   local v2584 = Instance.new("Sound");
   v2584.Looped = true;
   v2584.SoundId = "rbxassetid://866649671";
   v2584.Volume = 0;
   v2584.Parent = workspace;
   local u858 = v1380;
   local u859 = v2584;
   local u860 = v5;
   local u861 = v30;
   local u862 = v1367;
   local u863 = v12;
   local u864 = v1362;
   local u865 = t_soundfonts_208;
   local u866 = v41;
   local f_isdirtyfloat = f_isdirtyfloat;
   local u867 = v18;
   local f_statechange;
   f_statechange = function(p415, p416)
      --[[
         Name: statechange
         Upvalues: 
            1 => u858
            2 => u859
            3 => u860
            4 => u386
            5 => u861
            6 => u862
            7 => u863
            8 => u864
            9 => u395
            10 => u865
            11 => u866
            12 => f_isdirtyfloat
            13 => u867
   
      --]]
      local v2585 = Enum.HumanoidStateType.Climbing;
      if (p415 == v2585) then
         local v2586 = Enum.HumanoidStateType.Climbing;
         if (p416 ~= v2586) then
            u858.t = 0;
         end
      end
      local v2587 = Enum.HumanoidStateType.Freefall;
      if (p416 == v2587) then
         u859.Volume = 0;
         u859:Play();
         while (u859.Playing) do
            if (not u860.alive) then
               u859:Stop();
               u859.Volume = 0;
            end
            local v2588 = math.abs(u386.Velocity.Y / 80) ^ 5;
            if (v2588 < 0) then
               v2588 = 0;
            end
            local v2589 = false;
            local v2590 = u859;
            local v2591;
            if (v2588 <= 0.75) then
               v2591 = v2588;
               if (not v2591) then
                  v2589 = true;
               end
            else
               v2589 = true;
            end
            if (v2589) then
               v2591 = 0.75;
            end
            v2590.Volume = v2591;
            game:GetService("RunService").RenderStepped:wait();
         end
      else
         local v2592 = Enum.HumanoidStateType.Climbing;
         if (p416 == v2592) then
            local v2593 = workspace:FindPartOnRayWithWhitelist(u862(u861.cframe.p, u861.lookvector * 2), u863.raycastwhitelist);
            if (v2593 and v2593:IsA("TrussPart")) then
               u858.t = 1;
               return;
            end
         else
            local v2594 = Enum.HumanoidStateType.Landed;
            if (p416 == v2594) then
               u859:Stop();
               local v2595 = u864(0, u861.angles.y, 0) + u386.Position;
               local v2596 = u395.FloorMaterial;
               local t_FloorMaterial_369 = v2596;
               local v2597 = workspace.Gravity;
               local v2598 = u386.Velocity.y;
               local v2599 = (v2598 * v2598) / (2 * v2597);
               if (((v2599 > 2) and v2596) and u860.alive) then
                  local v2600 = u865[t_FloorMaterial_369];
                  local v2601 = v2600;
                  if (v2600) then
                     u866.PlaySound(v2601 .. "Land", "SelfFoley", 0.25);
                  end
               end
               if (v2599 > 12) then
                  u866.PlaySound("landHard", "SelfFoley", 0.25);
               end
               if (v2599 > 16) then
                  u866.PlaySound("landNearDeath", "SelfFoley", 0.25);
                  if (f_isdirtyfloat(v2599)) then
                     v2599 = 100;
                  end
                  u867:send("falldamage", v2599);
               end
            end
         end
      end
   end;
   u395.StateChanged:connect(f_statechange);
   local f_dealwithit = f_dealwithit;
   local u868 = v5;
   local u869 = v1366;
   local u870 = v1360;
   local u871 = v30;
   local u872 = v1423;
   local u873 = t_LocalPlayer_204;
   local u874 = v1369;
   local u875 = v18;
   local f_loadcharacter;
   f_loadcharacter = function(p417, p418)
      --[[
         Name: loadcharacter
         Upvalues: 
            1 => f_dealwithit
            2 => u831
            3 => u868
            4 => u869
            5 => u386
            6 => u387
            7 => u870
            8 => u871
            9 => u395
            10 => u872
            11 => u873
            12 => u874
            13 => u875
   
      --]]
      local v2602 = p417:GetDescendants();
      local v2603 = v2602;
      local v2604 = 1;
      local v2605 = #v2602;
      local v2606 = v2605;
      local v2607 = v2604;
      if (not (v2605 <= v2607)) then
         while true do
            f_dealwithit(v2603[v2604]);
            local v2608 = v2604 + 1;
            v2604 = v2608;
            local v2609 = v2606;
            if (v2609 < v2608) then
               break;
            end
         end
      end
      u831 = 0;
      u868.distance = 0;
      u868.velocity = u869;
      u868.speed = 0;
      local g_next_370 = next;
      local v2610, v2611 = p417:GetChildren();
      local v2612 = v2610;
      local v2613 = v2611;
      while true do
         local v2614, v2615 = g_next_370(v2612, v2613);
         local v2616 = v2614;
         local v2617 = v2615;
         if (v2614) then
            v2613 = v2616;
            v2617.CollisionGroupId = 1;
            v2617.CastShadow = false;
         else
            break;
         end
      end
      u386 = p417:WaitForChild("HumanoidRootPart");
      u386.Position = p418;
      u386.CanCollide = false;
      u868.rootpart = u386;
      u387 = u386:WaitForChild("RootJoint");
      u387.C0 = u870;
      u387.C1 = u870;
      u871.currentcamera.CameraSubject = u395;
      u395.Parent = p417;
      u872.Parent = u386;
      u873.Character = p417;
      u874[(#u874) + 1] = p417.DescendantAdded:connect(f_dealwithit);
      u874[(#u874) + 1] = u386.Touched:connect(function(p419)
         --[[
            Name: (empty)
            Upvalues: 
               1 => u875
   
         --]]
         local v2618 = string.lower(p419.Name);
         if (v2618 == "killwall") then
            u875:send("forcereset");
         end
      end);
   end;
   v5.loadcharacter = f_loadcharacter;
   local v2619 = v5.ondied;
   local u876 = v1369;
   v2619:connect(function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => u876
   
      --]]
      local v2620 = 1;
      local v2621 = #u876;
      local v2622 = v2621;
      local v2623 = v2620;
      if (not (v2621 <= v2623)) then
         while true do
            u876[v2620]:Disconnect();
            u876[v2620] = nil;
            local v2624 = v2620 + 1;
            v2620 = v2624;
            local v2625 = v2622;
            if (v2625 < v2624) then
               break;
            end
         end
      end
   end);
   local v2626 = 2 * math.pi;
   local v2627 = math.sin;
   local v2628 = math.random;
   local v2629 = table.insert;
   local v2630 = table.remove;
   local v2631 = Vector3.new;
   local v2632 = v2631();
   local v2633 = v2632.Dot;
   local v2634 = v21.anglesyx;
   local v2635 = Ray.new;
   local v2636 = CFrame.new;
   local v2637 = CFrame.Angles;
   local v2638 = v23.direct;
   local v2639 = v23.jointleg;
   local v2640 = v23.jointarm;
   local v2641 = v23.interpolate;
   local v2642 = Instance.new;
   local v2643 = v2636();
   local v2644 = v2643.toObjectSpace;
   local v2645 = v2643.vectorToWorldSpace;
   local v2646 = v2643.pointToObjectSpace;
   local v2647 = v2643.vectorToObjectSpace;
   local v2648 = game.FindFirstChild;
   local v2649 = v2631(0, 0, -1);
   local v2650 = v2631(0, 1, 0);
   local v2651 = v2631(0, -1.5, 0);
   local v2652 = tick();
   local u877 = tick();
   local v2653 = {};
   local v2654 = table.create(game:GetService("Players").MaxPlayers);
   local v2655 = game:GetService("Players").LocalPlayer;
   local v2656 = game:GetService("ReplicatedStorage");
   local v2657 = v2656:WaitForChild("ExternalModels");
   local v2658 = v2656:WaitForChild("Effects"):WaitForChild("MuzzleLight");
   local v2659 = workspace:WaitForChild("Players");
   local v2660 = workspace:FindFirstChild("Map");
   local v2661 = workspace:FindFirstChild("Ignore");
   local v2662 = v2636(0, 0, -0.5, 1, 0, 0, 0, 0, -1, 0, 1, 0);
   local v2663 = v23.interpolator(v2636(0, -0.125, 0), v2636(0, -1, 0) * v2637((-v2626) / 24, 0, 0));
   local v2664 = v23.interpolator(v2636(0, -1, 0) * v2637((-v2626) / 24, 0, 0), v2636(0, -2, 0.5) * v2637((-v2626) / 4, 0, 0));
   local v2665 = v41.soundfonts;
   local t_Dot_371 = v2633;
   local f_hitdist;
   f_hitdist = function(p420, p421, p422, p423)
      --[[
         Name: hitdist
         Upvalues: 
            1 => t_Dot_371
   
      --]]
      local v2666 = p421 - p420;
      local v2667 = v2666;
      local t_magnitude_372 = v2666.magnitude;
      if (not (t_magnitude_372 > 0)) then
         return 0;
      end
      local v2668 = p420 - p423;
      local v2669 = t_Dot_371(v2668, v2667) / t_magnitude_372;
      local v2670 = v2669;
      local v2671 = ((p422 * p422) + (v2669 * v2669)) - t_Dot_371(v2668, v2668);
      if (not (v2671 > 0)) then
         return 1;
      end
      local v2672 = (v2671 ^ 0.5) - v2670;
      if (v2672 > 0) then
         return t_magnitude_372 / v2672, v2672 - t_magnitude_372;
      end
      return 1;
   end;
   local f_hittarget;
   f_hittarget = function(p424, p425, p426)
      --[[
         Name: hittarget
      --]]
      local v2673 = p425 - p424;
      local v2674 = v2673;
      local t_magnitude_373 = v2673.magnitude;
      if (t_magnitude_373 > 0) then
         return p425 + ((p426 / t_magnitude_373) * v2674);
      end
      return p425;
   end;
   local v2675 = v2636(0.5, 0.5, 0, 0.9187516570000001, -0.309533417, -0.245118901, 0.369528353, 0.455418497, 0.809963167, -0.139079139, -0.834734678, 0.532798767);
   local v2676 = v2636(-0.5, 0.5, 0, 0.9187516570000001, 0.309533417, 0.245118901, -0.369528353, 0.455418497, 0.809963167, 0.139079139, -0.834734678, 0.532798767);
   local u878 = v2631;
   local u879 = v2628;
   local f_pickv3;
   f_pickv3 = function(p427, p428)
      --[[
         Name: pickv3
         Upvalues: 
            1 => u878
            2 => u879
   
      --]]
      return p427 + (u878(u879(), u879(), u879()) * (p428 - p427));
   end;
   local v2677 = {};
   local v2678 = {};
   local u880 = v2677;
   local u881 = v2678;
   local f_setcharacterhash;
   f_setcharacterhash = function(p429, p430, p431)
      --[[
         Name: setcharacterhash
         Upvalues: 
            1 => u880
            2 => u881
   
      --]]
      u880[p430] = p429;
      u881[p429] = p431;
   end;
   local u882 = v2677;
   local u883 = v2678;
   local f_removecharacterhash;
   f_removecharacterhash = function(p432)
      --[[
         Name: removecharacterhash
         Upvalues: 
            1 => u882
            2 => u883
   
      --]]
      local g_next_374 = next;
      local v2679 = u882;
      local v2680 = nil;
      while true do
         local v2681, v2682 = g_next_374(v2679, v2680);
         local v2683 = v2681;
         local v2684 = v2682;
         if (v2681) then
            v2680 = v2683;
            if (v2684 == p432) then
               u882[v2683] = nil;
            end
         else
            break;
         end
      end
      u883[p432] = nil;
   end;
   local u884 = v2677;
   local f_getfastplayerhit;
   f_getfastplayerhit = function(p433)
      --[[
         Name: getfastplayerhit
         Upvalues: 
            1 => u884
   
      --]]
      local v2685 = p433.Parent;
      local t_Parent_375 = v2685;
      if (v2685) then
         return u884[t_Parent_375];
      end
   end;
   v10.getplayerhit = f_getfastplayerhit;
   v10.removecharacterhash = f_removecharacterhash;
   local u885 = nil;
   local v2686 = shared.require("Math");
   local v2687 = shared.require("CloseCast");
   local v2688 = shared.require("InputType");
   local v2689 = {
      "head",
      "torso",
      "lleg",
      "rleg",
      "larm",
      "rarm"
   };
   local u886 = shared.require("HitBoxConfig");
   local u887 = v2678;
   local t_LocalPlayer_376 = v2655;
   local u888 = v2686;
   local u889 = v2689;
   local u890 = v2687;
   local f_playerHitCheck;
   f_playerHitCheck = function(p434, p435)
      --[[
         Name: playerHitCheck
         Upvalues: 
            1 => u886
            2 => u887
            3 => t_LocalPlayer_376
            4 => u888
            5 => u889
            6 => u885
            7 => u890
   
      --]]
      local v2690 = {};
      local v2691 = u886:get();
      local g_next_377 = next;
      local v2692 = u887;
      local v2693 = nil;
      while true do
         local v2694, v2695 = g_next_377(v2692, v2693);
         local v2696 = v2694;
         local v2697 = v2695;
         if (v2694) then
            v2693 = v2696;
            local v2698 = v2696.TeamColor;
            local t_TeamColor_378 = t_LocalPlayer_376.TeamColor;
            if (v2698 ~= t_TeamColor_378) then
               local v2699 = v2697.torso.Position;
               local v2700 = p434;
               local v2701 = v2700;
               local v2702 = p435 - p434;
               local v2703 = v2702;
               if (u888.doesRayIntersectSphere(v2700, v2702, v2699, 6)) then
                  local v2704 = false;
                  local v2705 = nil;
                  local v2706 = nil;
                  local v2707 = -(1/0);
                  local v2708 = nil;
                  local v2709 = nil;
                  local v2710 = -(1/0);
                  local v2711 = nil;
                  local v2712 = 1;
                  local v2713 = #u889;
                  local v2714 = v2713;
                  local v2715 = v2712;
                  if (v2713 <= v2715) then
                     v2704 = true;
                  else
                     while true do
                        local v2716 = v2697[u889[v2712]];
                        local v2717 = v2716;
                        local t_precedence_379 = v2691[v2716.Name].precedence;
                        local v2718 = u885;
                        if (not v2718) then
                           v2718 = v2691[v2717.Name].radius;
                        end
                        local v2719, v2720, v2721, v2722 = u890.closeCastPart(v2717, v2701, v2703);
                        local v2723 = v2721;
                        local v2724 = v2722;
                        if ((t_precedence_379 < v2707) and (v2724 < v2718)) then
                           v2707 = t_precedence_379;
                           v2705 = v2717;
                           v2706 = v2724;
                           v2708 = v2723;
                        end
                        if ((t_precedence_379 < v2710) and (v2724 == 0)) then
                           v2710 = t_precedence_379;
                           v2709 = v2717;
                           v2711 = v2723;
                        end
                        local v2725 = v2712 + 1;
                        v2712 = v2725;
                        local v2726 = v2714;
                        if (v2726 < v2725) then
                           break;
                        end
                     end
                     v2704 = true;
                  end
                  if (v2704) then
                     if (v2705) then
                        local v2727 = {};
                        v2727.bestPart = v2705;
                        v2727.bestDistance = v2706;
                        v2727.bestNearestPosition = v2708;
                        v2727.bestDirectPart = v2709;
                        v2727.bestDirectNearestPosition = v2711;
                        v2690[v2696] = v2727;
                     end
                  end
               end
            end
         else
            break;
         end
      end
      return v2690;
   end;
   v10.thickcastplayers = f_playerHitCheck;
   v18:add("lolhi", function(p436)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u885
   
      --]]
      u885 = p436;
   end);
   local u891 = v2678;
   local f_getbodyparts;
   f_getbodyparts = function(p437)
      --[[
         Name: getbodyparts
         Upvalues: 
            1 => u891
   
      --]]
      return u891[p437];
   end;
   v10.getbodyparts = f_getbodyparts;
   local u892 = v2678;
   local f_getallparts;
   f_getallparts = function()
      --[[
         Name: getallparts
         Upvalues: 
            1 => u892
   
      --]]
      local v2728 = {};
      local g_next_380 = next;
      local v2729 = u892;
      local v2730 = nil;
      while true do
         local v2731, v2732 = g_next_380(v2729, v2730);
         local v2733 = v2731;
         local v2734 = v2732;
         if (v2731) then
            v2730 = v2733;
            local g_next_381 = next;
            local v2735 = v2734;
            local v2736 = nil;
            while true do
               local v2737, v2738 = g_next_381(v2735, v2736);
               local v2739 = v2737;
               local v2740 = v2738;
               if (v2737) then
                  v2736 = v2739;
                  if (v2740.Parent) then
                     v2728[(#v2728) + 1] = v2740;
                  end
               else
                  break;
               end
            end
         else
            break;
         end
      end
      return v2728;
   end;
   v10.getallparts = f_getallparts;
   local t_FindFirstChild_382 = v2648;
   local u893 = v2642;
   local u894 = v35;
   local f_weld3pm;
   f_weld3pm = function(p438, p439)
      --[[
         Name: weld3pm
         Upvalues: 
            1 => t_FindFirstChild_382
            2 => u893
            3 => u894
   
      --]]
      local v2741 = nil;
      local v2742 = t_FindFirstChild_382(p438, "Slot1");
      local v2743 = v2742;
      if (not (v2742 and t_FindFirstChild_382(p438, "Slot2"))) then
         print("Incomplete third person model", p438);
         return;
      end
      local g_next_383 = next;
      local v2744, v2745 = p438:GetChildren();
      local v2746 = v2744;
      local v2747 = v2745;
      while true do
         local v2748, v2749 = g_next_383(v2746, v2747);
         local v2750 = v2748;
         local v2751 = v2749;
         if (v2748) then
            v2747 = v2750;
            if (v2751:IsA("BasePart")) then
               local t_Name_384 = v2751.Name;
               if (t_Name_384 == "Flame") then
                  v2741 = v2751;
               end
               if (v2751 ~= v2743) then
                  local v2752 = u893("Weld");
                  v2752.Part0 = v2743;
                  v2752.Part1 = v2751;
                  v2752.C0 = v2743.CFrame:inverse() * v2751.CFrame;
                  v2752.Parent = v2743;
               end
               if (((not u894.disable3pcamoskins) and p439) and p439[v2751.Name]) then
                  local t_Name_385 = p439[v2751.Name].Name;
                  if (t_Name_385 ~= "") then
                     local t_BrickProperties_386 = p439[v2751.Name].BrickProperties;
                     local v2753 = p439[v2751.Name].TextureProperties;
                     local t_TextureProperties_387 = v2753;
                     local v2754 = u893("Texture");
                     local v2755 = v2754;
                     v2754.Name = v2751.Name;
                     v2754.Texture = "rbxassetid://" .. v2753.TextureId;
                     v2754.Transparency = v2753.Transparency or 0;
                     v2754.StudsPerTileU = v2753.StudsPerTileU or 1;
                     v2754.StudsPerTileV = v2753.StudsPerTileV or 1;
                     v2754.OffsetStudsU = v2753.OffsetStudsU or 0;
                     v2754.OffsetStudsV = v2753.OffsetStudsV or 0;
                     if (v2753.Color) then
                        local v2756 = t_TextureProperties_387.Color;
                        v2755.Color3 = Color3.new(v2756.r / 255, v2756.g / 255, v2756.b / 255);
                     end
                     local v2757 = 0;
                     local v2758;
                     if (v2751:IsA("MeshPart")) then
                        v2758 = 5;
                     else
                        v2758 = 0;
                     end
                     local v2759 = v2757;
                     local v2760 = v2758;
                     if (not (v2760 <= v2759)) then
                        while true do
                           local v2761 = v2755:Clone();
                           v2761.Face = v2757;
                           v2761.Parent = v2751;
                           local v2762 = v2757 + 1;
                           v2757 = v2762;
                           local v2763 = v2758;
                           if (v2763 < v2762) then
                              break;
                           end
                        end
                     end
                     local t_DefaultColor_388 = t_BrickProperties_386.DefaultColor;
                     if (t_DefaultColor_388 ~= true) then
                        local v2764 = t_BrickProperties_386.Color;
                        local t_Color_389 = v2764;
                        if (v2764) then
                           v2751.Color = Color3.new(t_Color_389.r / 255, t_Color_389.g / 255, t_Color_389.b / 255);
                        else
                           if (t_BrickProperties_386.BrickColor) then
                              v2751.BrickColor = BrickColor.new(t_BrickProperties_386.BrickColor);
                           end
                        end
                     end
                     if (t_BrickProperties_386.Material) then
                        v2751.Material = t_BrickProperties_386.Material;
                     end
                     if (t_BrickProperties_386.Reflectance) then
                        v2751.Reflectance = t_BrickProperties_386.Reflectance;
                     end
                  end
               end
               v2751.CastShadow = false;
               v2751.Massless = true;
               v2751.Anchored = false;
               v2751.CanCollide = false;
            end
         else
            break;
         end
      end
      return v2741;
   end;
   local t_LocalPlayer_390 = v2655;
   local u895 = v2642;
   local u896 = v31;
   local u897 = v2632;
   local u898 = v2643;
   local u899 = v2631;
   local u900 = v25;
   local u901 = v2658;
   local u902 = v2636;
   local u903 = v2662;
   local f_weld3pm = f_weld3pm;
   local u904 = v2661;
   local u905 = v2660;
   local u906 = v2659;
   local u907 = v35;
   local f_pickv3 = f_pickv3;
   local u908 = v2653;
   local u909 = v2629;
   local u910 = v2630;
   local u911 = v30;
   local u912 = v28;
   local t_FindFirstChild_391 = v2648;
   local f_setcharacterhash = f_setcharacterhash;
   local u913 = v2637;
   local u914 = v2663;
   local u915 = v2664;
   local u916 = v2627;
   local t_interpolate_392 = v2641;
   local f_hitdist = f_hitdist;
   local f_hittarget = f_hittarget;
   local u917 = v2635;
   local u918 = v2650;
   local u919 = v2651;
   local u920 = v12;
   local t_soundfonts_393 = v2665;
   local u921 = v41;
   local t_anglesyx_394 = v2634;
   local t_direct_395 = v2638;
   local u922 = v2649;
   local t_jointleg_396 = v2639;
   local u923 = v2626;
   local u924 = v23;
   local t_jointarm_397 = v2640;
   local u925 = v2676;
   local u926 = v2675;
   local u927 = v7;
   local u928 = v2657;
   local u929 = v18;
   local f_loadplayer;
   f_loadplayer = function(p440)
      --[[
         Name: loadplayer
         Upvalues: 
            1 => t_LocalPlayer_390
            2 => u895
            3 => u896
            4 => u897
            5 => u898
            6 => u899
            7 => u900
            8 => u901
            9 => u902
            10 => u903
            11 => f_weld3pm
            12 => u904
            13 => u905
            14 => u906
            15 => u907
            16 => f_pickv3
            17 => u908
            18 => u909
            19 => u910
            20 => u911
            21 => u912
            22 => t_FindFirstChild_391
            23 => f_setcharacterhash
            24 => u913
            25 => u914
            26 => u915
            27 => u916
            28 => t_interpolate_392
            29 => f_hitdist
            30 => f_hittarget
            31 => u917
            32 => u918
            33 => u919
            34 => u920
            35 => t_soundfonts_393
            36 => u921
            37 => t_anglesyx_394
            38 => t_direct_395
            39 => u922
            40 => t_jointleg_396
            41 => u923
            42 => u924
            43 => t_jointarm_397
            44 => u925
            45 => u926
            46 => u927
            47 => f_gunrequire
            48 => u928
            49 => u929
   
      --]]
      local v2765 = t_LocalPlayer_390;
      if (p440 == v2765) then
         return;
      end
      local u930 = nil;
      local u931 = nil;
      local u932 = nil;
      local u933 = nil;
      local v2766 = u895("Motor6D");
      local v2767 = u895("Motor6D");
      local v2768 = u895("Motor6D");
      local v2769 = u895("Motor6D");
      local v2770 = {};
      local v2771 = {};
      local v2772 = u896.new();
      local u934 = nil;
      local u935 = nil;
      local u936 = nil;
      local u937 = nil;
      local u938 = nil;
      local u939 = 0;
      local u940 = u897;
      local u941 = u897;
      local u942 = u897;
      local u943 = u897;
      local u944 = u898;
      local u945 = u898;
      local u946 = u898;
      local u947 = u898;
      local u948 = u898;
      local u949 = u898;
      local u950 = u899(0, -1, 0);
      local u951 = u897;
      local u952 = u899(0, 0, -1);
      local u953 = u898;
      local u954 = false;
      local v2773 = u900.new();
      v2773.s = 12;
      v2773.d = 0.8;
      local v2774 = u900.new(1);
      v2774.s = 12;
      local v2775 = u900.new();
      v2775.s = 20;
      v2775.d = 0.8;
      local v2776 = u900.new(u897);
      local v2777 = u900.new(u897);
      local v2778 = u901:Clone();
      local v2779 = u895("Motor6D");
      local u955 = u897;
      local v2780 = u900.new(u897);
      v2780.s = 3;
      v2771.remp = 0;
      local v2781 = u900.new(u897);
      v2781.s = 32;
      local v2782 = u900.new(0);
      v2782.s = 4;
      v2782.d = 0.8;
      local v2783 = u900.new(0);
      v2783.s = 8;
      local v2784 = u900.new(1);
      v2784.s = 8;
      local u956 = 0;
      local v2785 = u900.new(u897);
      v2785.s = 16;
      v2785.d = 0.75;
      local v2786 = u900.new(0);
      v2786.s = 50;
      v2786.d = 1;
      local u957 = 1;
      local v2787 = {};
      v2787.center = u898;
      v2787.pos = u897;
      v2787.sdown = u902(0.5, -3, 0);
      v2787.pdown = u902(0.5, -2.75, 0);
      v2787.weld = v2769;
      v2787.hipcf = u902(0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
      v2787.legcf = u903;
      v2787.angm = 1;
      v2787.torsoswing = 0.1;
      local v2788 = {};
      v2788.makesound = true;
      v2788.center = u898;
      v2788.pos = u897;
      v2788.sdown = u902(-0.5, -3, 0);
      v2788.pdown = u902(-0.5, -2.75, 0);
      v2788.weld = v2768;
      v2788.hipcf = u902(-0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
      v2788.legcf = u903;
      v2788.angm = -1;
      v2788.torsoswing = -0.1;
      local u958 = v2787;
      local u959 = v2788;
      local v2789 = u895("SoundGroup");
      local v2790 = u895("EqualizerSoundEffect");
      v2790.HighGain = 0;
      v2790.MidGain = 0;
      v2790.LowGain = 0;
      v2790.Parent = v2789;
      v2789.Parent = game:GetService("SoundService");
      v2770.alive = false;
      local u960 = v2772;
      local u961 = v2773;
      local u962 = v2779;
      local f_equipknife;
      f_equipknife = function(p441, p442, p443)
         --[[
            Name: equipknife
            Upvalues: 
               1 => u960
               2 => u936
               3 => u961
               4 => u962
               5 => u937
               6 => u938
               7 => u945
               8 => u902
               9 => u946
               10 => u947
               11 => u949
               12 => u952
               13 => u944
               14 => u950
               15 => u951
               16 => u953
               17 => u935
               18 => f_weld3pm
               19 => u932
   
         --]]
         if (p441) then
            u960:clear();
            if (u936) then
               u961.t = 0;
               u960:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u961
   
                  --]]
                  return u961.p < 0;
               end);
               u960:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u936
                        2 => u962
   
                  --]]
                  u936.Slot1.Transparency = 1;
                  u936.Slot2.Transparency = 1;
                  u962.Part1 = nil;
                  u936:Destroy();
               end);
            end
            local v2791 = u960;
            local u963 = p441;
            local u964 = p442;
            local u965 = p443;
            v2791:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u937
                     2 => u938
                     3 => u963
                     4 => u945
                     5 => u902
                     6 => u946
                     7 => u947
                     8 => u949
                     9 => u952
                     10 => u944
                     11 => u950
                     12 => u951
                     13 => u953
                     14 => u936
                     15 => u964
                     16 => u935
                     17 => f_weld3pm
                     18 => u965
                     19 => u932
                     20 => u962
                     21 => u961
   
               --]]
               u937 = "KNIFE";
               u938 = u963.dualhand;
               u945 = u902(u963.offset3p.p);
               u946 = u963.offset3p - u963.offset3p.p;
               u947 = u963.pivot3p;
               u949 = u963.drawcf3p;
               u952 = u963.forward3p;
               u944 = u963.sprintcf3p;
               u950 = u963.lhold3p;
               u951 = u963.rhold3p;
               u953 = u963.stabcf3p;
               u936 = u964:Clone();
               u935 = f_weld3pm(u936, u965);
               u936.Name = "Model";
               u936.Parent = u932.Parent;
               u962.Part1 = u936.Slot1;
               u961.t = 1;
            end);
         end
      end;
      v2770.equipknife = f_equipknife;
      local u966 = v2772;
      local u967 = v2773;
      local u968 = v2779;
      local u969 = v2776;
      local u970 = v2777;
      local f_equip;
      f_equip = function(p444, p445, p446)
         --[[
            Name: equip
            Upvalues: 
               1 => u966
               2 => u936
               3 => u967
               4 => u968
               5 => u937
               6 => u940
               7 => u941
               8 => u942
               9 => u943
               10 => u945
               11 => u902
               12 => u946
               13 => u947
               14 => u949
               15 => u952
               16 => u939
               17 => u944
               18 => u948
               19 => u969
               20 => u970
               21 => u950
               22 => u951
               23 => u935
               24 => f_weld3pm
               25 => u932
               26 => u934
   
         --]]
         if (p444) then
            u966:clear();
            if (u936) then
               u967.t = 0;
               u966:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u967
   
                  --]]
                  return u967.p < 0;
               end);
               u966:add(function()
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u936
                        2 => u968
   
                  --]]
                  u936.Slot1.Transparency = 1;
                  u936.Slot2.Transparency = 1;
                  u968.Part1 = nil;
                  u936:Destroy();
               end);
            end
            local v2792 = u966;
            local u971 = p444;
            local u972 = p445;
            local u973 = p446;
            v2792:add(function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u937
                     2 => u940
                     3 => u971
                     4 => u941
                     5 => u942
                     6 => u943
                     7 => u945
                     8 => u902
                     9 => u946
                     10 => u947
                     11 => u949
                     12 => u952
                     13 => u939
                     14 => u944
                     15 => u948
                     16 => u969
                     17 => u970
                     18 => u950
                     19 => u951
                     20 => u936
                     21 => u972
                     22 => u935
                     23 => f_weld3pm
                     24 => u973
                     25 => u932
                     26 => u968
                     27 => u967
                     28 => u934
   
               --]]
               u937 = "gun";
               u940 = u971.transkickmax;
               u941 = u971.transkickmin;
               u942 = u971.rotkickmax;
               u943 = u971.rotkickmin;
               u945 = u902(u971.offset3p.p);
               u946 = u971.offset3p - u971.offset3p.p;
               u947 = u971.pivot3p;
               u949 = u971.drawcf3p;
               u952 = u971.forward3p;
               u939 = u971.headaimangle3p or 0;
               u944 = u971.sprintcf3p;
               u948 = u971.aimpivot3p;
               u969.s = u971.modelkickspeed;
               u969.d = u971.modelkickdamper;
               u970.s = u971.modelkickspeed;
               u970.d = u971.modelkickdamper;
               u950 = u971.lhold3p;
               u951 = u971.rhold3p;
               u936 = u972:Clone();
               u935 = f_weld3pm(u936, u973);
               u936.Name = "Model";
               u936.Parent = u932.Parent;
               u968.Part1 = u936.Slot1;
               u967.t = 1;
               if (u971.firesoundid) then
                  u934 = u971.firesoundid;
               end
            end);
         end
      end;
      v2770.equip = f_equip;
      local f_getweaponpos;
      f_getweaponpos = function()
         --[[
            Name: getweaponpos
            Upvalues: 
               1 => u935
               2 => u936
               3 => u946
               4 => u899
               5 => u933
   
         --]]
         if (u935) then
            return u935.CFrame.p;
         end
         if (u936) then
            return (u936.Slot1.CFrame * u946:inverse()) * u899(0, 0, -2);
         end
         if (u933) then
            return u933.Position;
         end
      end;
      v2770.getweaponpos = f_getweaponpos;
      local u974 = v2775;
      local u975 = p440;
      local f_stab;
      f_stab = function()
         --[[
            Name: stab
            Upvalues: 
               1 => u936
               2 => u937
               3 => u974
               4 => u904
               5 => u905
               6 => u906
               7 => u975
               8 => u933
               9 => u907
               10 => u899
   
         --]]
         if (u936) then
            local v2793 = u937;
            if (v2793 == "KNIFE") then
               u974.a = 47;
               local v2794 = {
                  u904,
                  u905,
                  u906:FindFirstChild(u975.Team.Name)
               };
               local v2795 = u933.CFrame;
               local t_CFrame_398 = v2795;
               local v2796, v2797, v2798 = workspace:FindPartOnRayWithIgnoreList(Ray.new(v2795.p, v2795.LookVector * 5), v2794);
               local v2799 = v2797;
               if (v2796) then
                  u907:bloodhit(v2799, true, 85, u899(0, -8, 0) + ((v2799 - t_CFrame_398.p).unit * 8), true);
               end
            end
         end
      end;
      v2770.stab = f_stab;
      local u976 = v2774;
      local u977 = v2776;
      local u978 = v2777;
      local u979 = v2789;
      local u980 = v2790;
      local u981 = v2786;
      local f_kickweapon;
      f_kickweapon = function(p447, p448, p449)
         --[[
            Name: kickweapon
            Upvalues: 
               1 => u936
               2 => u937
               3 => u976
               4 => u977
               5 => f_pickv3
               6 => u941
               7 => u940
               8 => u978
               9 => u943
               10 => u942
               11 => u908
               12 => u895
               13 => u909
               14 => u910
               15 => u979
               16 => u934
               17 => u933
               18 => u911
               19 => u980
               20 => u907
               21 => u935
               22 => u912
               23 => u981
               24 => t_FindFirstChild_391
   
         --]]
         if (u936) then
            local v2800 = u937;
            if (v2800 == "gun") then
               local v2801 = u976.p;
               u977.a = f_pickv3(u941, u940);
               u978.a = f_pickv3(u943, u942);
               local v2802 = #u908;
               local u982;
               if (v2802 == 0) then
                  u982 = u895("Sound");
                  u982.Ended:connect(function()
                     --[[
                        Name: (empty)
                        Upvalues: 
                           1 => u982
                           2 => u908
                           3 => u909
   
                     --]]
                     u982.Parent = nil;
                     u909(u908, u982);
                  end);
               else
                  u982 = u910(u908, 1);
               end
               u982.SoundGroup = u979;
               u982.SoundId = u934;
               if (p448) then
                  u982.Pitch = p448;
               end
               if (p449) then
                  u982.Volume = p449;
               end
               local v2803 = (-(u933.Position - u911.cframe.p).magnitude) / 14.6484;
               u980.HighGain = v2803;
               u980.MidGain = v2803;
               u982.Parent = u933;
               u982:Play();
               if ((u907.enablemuzzleeffects and u935) and u912.point(u935.Position)) then
                  if (not p447) then
                     u981.a = 125;
                  end
                  local v2804 = t_FindFirstChild_391(u935, "Smoke");
                  if (not p447) then
                     local g_next_399 = next;
                     local v2805, v2806 = u935:GetChildren();
                     local v2807 = v2805;
                     local v2808 = v2806;
                     while true do
                        local v2809, v2810 = g_next_399(v2807, v2808);
                        local v2811 = v2809;
                        local v2812 = v2810;
                        if (v2809) then
                           v2808 = v2811;
                           if ((not (v2812 == v2804)) and v2812:IsA("ParticleEmitter")) then
                              v2812:Emit(1);
                           end
                        else
                           break;
                        end
                     end
                  end
               end
            end
         end
      end;
      v2770.kickweapon = f_kickweapon;
      local f_getweapon;
      f_getweapon = function()
         --[[
            Name: getweapon
            Upvalues: 
               1 => u936
   
         --]]
         return u936;
      end;
      v2770.getweapon = f_getweapon;
      local u983 = p440;
      local u984 = v2766;
      local u985 = v2767;
      local u986 = v2768;
      local u987 = v2769;
      local u988 = v2779;
      local u989 = v2778;
      local u990 = v2770;
      local f_updatecharacter;
      f_updatecharacter = function(p450)
         --[[
            Name: updatecharacter
            Upvalues: 
               1 => u983
               2 => u931
               3 => u932
               4 => u930
               5 => u933
               6 => u898
               7 => u984
               8 => u985
               9 => u986
               10 => u987
               11 => u988
               12 => u989
               13 => f_setcharacterhash
               14 => u990
               15 => u955
   
         --]]
         if (not u983.Parent) then
            return;
         end
         if (u931) then
            local t_Parent_401 = u931.Parent;
            if (p450 == t_Parent_401) then
               return;
            end
         end
         u931 = p450:WaitForChild("Head");
         u932 = p450:WaitForChild("Torso");
         u930 = u932:WaitForChild("Neck");
         u933 = p450:WaitForChild("HumanoidRootPart");
         local v2813 = p450:WaitForChild("Right Arm");
         local v2814 = p450:WaitForChild("Left Arm");
         local v2815 = p450:WaitForChild("Right Leg");
         local v2816 = p450:WaitForChild("Left Leg");
         local g_next_400 = next;
         local v2817, v2818 = p450:GetChildren();
         local v2819 = v2817;
         local v2820 = v2818;
         while true do
            local v2821, v2822 = g_next_400(v2819, v2820);
            local v2823 = v2821;
            local v2824 = v2822;
            if (v2821) then
               v2820 = v2823;
               if (v2824:IsA("BasePart")) then
                  v2824.CanCollide = false;
                  v2824.CastShadow = false;
               end
            else
               break;
            end
         end
         u930.C1 = u898;
         u932:WaitForChild("Left Hip"):Destroy();
         u932:WaitForChild("Right Hip"):Destroy();
         u932:WaitForChild("Left Shoulder"):Destroy();
         u932:WaitForChild("Right Shoulder"):Destroy();
         u933:WaitForChild("RootJoint"):Destroy();
         u932.Anchored = true;
         u984.Part0 = u932;
         u985.Part0 = u932;
         u986.Part0 = u932;
         u987.Part0 = u932;
         u984.Part1 = v2814;
         u985.Part1 = v2813;
         u986.Part1 = v2816;
         u987.Part1 = v2815;
         u988.Part0 = u932;
         u984.Parent = u932;
         u985.Parent = u932;
         u986.Parent = u932;
         u987.Parent = u932;
         u988.Parent = u932;
         u989.Parent = u933;
         local v2825 = {};
         v2825.head = u931;
         v2825.torso = u932;
         v2825.lleg = v2816;
         v2825.rleg = v2815;
         v2825.larm = v2814;
         v2825.rarm = v2813;
         v2825.rootpart = u933;
         f_setcharacterhash(u983, p450, v2825);
         u990.alive = true;
         u955 = u933.Position;
      end;
      v2770.updatecharacter = f_updatecharacter;
      local u991 = v2784;
      local f_setsprint;
      f_setsprint = function(p451)
         --[[
            Name: setsprint
            Upvalues: 
               1 => u991
   
         --]]
         local v2826 = u991;
         local v2827;
         if (p451) then
            v2827 = 0;
         else
            v2827 = 1;
         end
         v2826.t = v2827;
      end;
      v2770.setsprint = f_setsprint;
      local u992 = v2774;
      local f_setaim;
      f_setaim = function(p452)
         --[[
            Name: setaim
            Upvalues: 
               1 => u992
   
         --]]
         local v2828 = u992;
         local v2829;
         if (p452) then
            v2829 = 0;
         else
            v2829 = 1;
         end
         v2828.t = v2829;
      end;
      v2770.setaim = f_setaim;
      local u993 = v2782;
      local f_setstance;
      f_setstance = function(p453)
         --[[
            Name: setstance
            Upvalues: 
               1 => u993
   
         --]]
         local v2830 = u993;
         local v2831;
         if (p453 == "stand") then
            v2831 = 0;
         else
            if (p453 == "crouch") then
               v2831 = 0.5;
            else
               v2831 = 1;
            end
         end
         v2830.t = v2831;
      end;
      v2770.setstance = f_setstance;
      local u994 = v2785;
      local f_setlookangles;
      f_setlookangles = function(p454)
         --[[
            Name: setlookangles
            Upvalues: 
               1 => u994
               2 => u899
   
         --]]
         u994.t = u899(p454.x, p454.y);
      end;
      v2770.setlookangles = f_setlookangles;
      local f_getrootcf;
      f_getrootcf = function()
         --[[
            Name: getrootcf
            Upvalues: 
               1 => u933
               2 => u913
               3 => u956
               4 => u955
   
         --]]
         local v2832 = u933.CFrame;
         local v2833 = u933.Position;
         local v2834 = u913(0, u956, 0) + v2833;
         local v2835 = u933.AssemblyLinearVelocity;
         u955 = v2833;
         return v2834, v2835;
      end;
      local f_getpos;
      f_getpos = function()
         --[[
            Name: getpos
            Upvalues: 
               1 => u933
               2 => u931
   
         --]]
         local v2836 = u933;
         if (v2836) then
            v2836 = u933.Position;
         end
         local v2837 = u931;
         if (v2837) then
            v2837 = u931.Position;
         end
         return v2836, v2837;
      end;
      v2770.getpos = f_getpos;
      local f_gethead;
      f_gethead = function()
         --[[
            Name: gethead
            Upvalues: 
               1 => u931
   
         --]]
         return u931;
      end;
      v2770.gethead = f_gethead;
      local u995 = v2785;
      local f_getlookangles;
      f_getlookangles = function()
         --[[
            Name: getlookangles
            Upvalues: 
               1 => u995
   
         --]]
         return u995.p;
      end;
      v2770.getlookangles = f_getlookangles;
      local u996 = v2770;
      local f_died;
      f_died = function()
         --[[
            Name: died
            Upvalues: 
               1 => u996
   
         --]]
         u996.alive = false;
      end;
      v2770.died = f_died;
      local u997 = p440;
      local f_getrootcf = f_getrootcf;
      local u998 = v2781;
      local u999 = v2780;
      local u1000 = v2783;
      local u1001 = v2772;
      local u1002 = v2782;
      local u1003 = v2784;
      local u1004 = v2785;
      local u1005 = v2771;
      local u1006 = v2773;
      local u1007 = v2774;
      local u1008 = v2778;
      local u1009 = v2786;
      local u1010 = v2776;
      local u1011 = v2777;
      local u1012 = v2766;
      local u1013 = v2767;
      local u1014 = v2779;
      local u1015 = v2775;
      local f_step;
      f_step = function(p455, p456)
         --[[
            Name: step
            Upvalues: 
               1 => u997
               2 => u933
               3 => f_getrootcf
               4 => u998
               5 => u897
               6 => u999
               7 => u899
               8 => u1000
               9 => u936
               10 => u954
               11 => u1001
               12 => u1002
               13 => u1003
               14 => u914
               15 => u915
               16 => u1004
               17 => u956
               18 => u913
               19 => u902
               20 => u916
               21 => u957
               22 => t_interpolate_392
               23 => u958
               24 => u959
               25 => f_hitdist
               26 => u1005
               27 => f_hittarget
               28 => u911
               29 => u917
               30 => u918
               31 => u919
               32 => u920
               33 => t_soundfonts_393
               34 => t_LocalPlayer_390
               35 => u921
               36 => u1006
               37 => t_anglesyx_394
               38 => t_direct_395
               39 => u922
               40 => u898
               41 => u932
               42 => t_jointleg_396
               43 => u923
               44 => u1007
               45 => u939
               46 => u930
               47 => u1008
               48 => u1009
               49 => u937
               50 => u948
               51 => u947
               52 => u945
               53 => u1010
               54 => u924
               55 => u1011
               56 => u946
               57 => u949
               58 => u944
               59 => u1012
               60 => t_jointarm_397
               61 => u925
               62 => u950
               63 => u903
               64 => u1013
               65 => u926
               66 => u951
               67 => u1014
               68 => u953
               69 => u1015
               70 => u938
   
         --]]
         debug.profilebegin("rep char " .. (p455 .. (" " .. u997.Name)));
         if (not u933) then
            debug.profileend();
            return;
         end
         local v2838, v2839 = f_getrootcf();
         local v2840 = v2838;
         local v2841 = v2839;
         local v2842 = v2838.p;
         local t_p_402 = v2842;
         u998.t = v2842;
         local t_magnitude_403 = (v2842 - u998.p).magnitude;
         if (t_magnitude_403 > 16) then
            u998.p = t_p_402;
            u998.v = u897;
         end
         u999.t = v2841 * u899(1, 0, 1);
         u1000.t = v2841.magnitude;
         if (u936) then
            if (p456 and (not u954)) then
               u936.Slot1.Transparency = 0;
               u936.Slot2.Transparency = 0;
               u954 = true;
            else
               if ((not p456) and u954) then
                  u936.Slot1.Transparency = 1;
                  u936.Slot2.Transparency = 1;
                  u954 = false;
               end
            end
         end
         if (p455 >= 1) then
            local v2843 = false;
            u1001:step();
            local v2844 = (v2840 - t_p_402) + u998.p;
            local v2845 = v2844;
            local t_p_404 = v2844.p;
            local v2846 = u1002.p;
            local t_p_405 = v2846;
            local t_p_406 = u1003.p;
            local v2847;
            if (v2846 < 0.5) then
               v2847 = u914(2 * t_p_405);
               if (not v2847) then
                  v2843 = true;
               end
            else
               v2843 = true;
            end
            if (v2843) then
               v2847 = u915((2 * t_p_405) - 1);
            end
            local v2848 = false;
            local v2849 = u1004.p;
            local t_x_407 = v2849.x;
            local v2850 = v2849.y;
            local t_y_408 = v2850;
            local v2851 = t_p_406 * 0.5;
            local v2852 = v2851;
            local v2853 = u956 - v2850;
            local v2854 = -v2851;
            local v2855;
            if (v2853 < v2854) then
               v2855 = t_y_408 - v2852;
               if (not v2855) then
                  v2848 = true;
               end
            else
               v2848 = true;
            end
            if (v2848) then
               local v2856 = false;
               local v2857 = u956 - t_y_408;
               if (v2852 < v2857) then
                  v2855 = t_y_408 + v2852;
                  if (not v2855) then
                     v2856 = true;
                  end
               else
                  v2856 = true;
               end
               if (v2856) then
                  v2855 = u956;
               end
            end
            local v2858 = false;
            u956 = v2855;
            local v2859 = (((u913(0, u956, 0) * u902(0, (0.05 * u916(2 * os.clock())) - 0.55, 0)) * v2847) * u902(0, 0.5, 0)) + t_p_404;
            local v2860;
            if (t_p_405 > 0.5) then
               v2860 = (2 * t_p_405) - 1;
               if (not v2860) then
                  v2858 = true;
               end
            else
               v2858 = true;
            end
            if (v2858) then
               v2860 = 0;
            end
            u957 = ((0.5 * (1 - t_p_405)) + 0.5) + ((1 - t_p_406) * 0.5);
            local v2861 = t_interpolate_392(v2845 * u958.sdown, v2859 * u958.pdown, v2860);
            local v2862 = v2861;
            local v2863 = t_interpolate_392(v2845 * u959.sdown, v2859 * u959.pdown, v2860);
            local v2864 = v2863;
            local t_p_409 = v2863.p;
            local v2865, v2866 = f_hitdist(u958.center.p, v2861.p, u957, u958.pos);
            local v2867 = v2865;
            local v2868 = v2866;
            if (v2866) then
               u1005.remp = v2868;
            end
            local v2869 = f_hittarget(u959.center.p, t_p_409, u957);
            if (v2867 < 1) then
               u959.pos = ((1 - v2867) * ((v2864 * u959.center:inverse()) * u959.pos)) + (v2867 * v2869);
               u958.center = v2862;
               u959.center = v2864;
            else
               u958.center = v2862;
               u959.center = v2864;
               local t_magnitude_410 = (u911.basecframe.p - t_p_409).magnitude;
               if (u959.makesound and (t_magnitude_410 < 192)) then
                  local v2870, v2871, v2872, v2873 = workspace:FindPartOnRayWithWhitelist(u917(t_p_409 + u918, u919), u920.raycastwhitelist, true);
                  local v2874 = v2873;
                  if (v2870) then
                     local v2875 = t_soundfonts_393[v2874];
                     local v2876 = v2875;
                     if (v2875) then
                        local v2877 = u997.TeamColor;
                        local t_TeamColor_414 = t_LocalPlayer_390.TeamColor;
                        local v2878, v2879;
                        if (v2877 == t_TeamColor_414) then
                           v2878 = "friendly_" .. v2876;
                           v2879 = 1.414213562373095 / (t_magnitude_410 / 5);
                        else
                           v2878 = "enemy_" .. v2876;
                           v2879 = 3.872983346207417 / (t_magnitude_410 / 5);
                        end
                        if (v2878 == "enemy_wood") then
                           v2879 = 3.16227766016838 / (t_magnitude_410 / 5);
                        end
                        local v2880;
                        if (u1000.p <= 15) then
                           v2880 = v2878 .. "walk";
                        else
                           v2880 = v2878 .. "run";
                        end
                        u921.PlaySound(v2880, nil, v2879, 1, nil, nil, u933, 192, 10);
                     end
                  end
               end
               u958.pos = v2862.p + (u957 * (u958.pos - v2862.p).unit);
               u959.pos = v2869;
               local v2881 = u959;
               local v2882 = u958;
               u958 = v2881;
               u959 = v2882;
            end
            if (p455 >= 2) then
               local v2883 = false;
               local t_v_411 = u999.v;
               local t_p_412 = u1006.p;
               local v2884 = t_anglesyx_394(t_x_407, t_y_408);
               local v2885 = u1000.p / 8;
               local v2886 = v2885;
               local v2887;
               if (v2885 < 1) then
                  v2887 = v2886;
                  if (not v2887) then
                     v2883 = true;
                  end
               else
                  v2883 = true;
               end
               if (v2883) then
                  v2887 = 1;
               end
               local v2888 = v2887;
               local v2889 = u1005.remp * (2 - (u1005.remp / u957));
               local v2890 = v2889;
               local v2891;
               if (v2889 < 0) then
                  v2891 = 0;
               else
                  v2891 = v2890;
               end
               local v2892 = v2891;
               local v2893 = v2892;
               local v2894 = (t_direct_395(v2859, u922, v2884, ((0.5 * t_p_406) * (1 - t_p_405)) * t_p_412) * u913(0, v2892 * u958.torsoswing, 0)) * u902(0, -3, 0);
               local v2895 = (((t_direct_395(u898, u899(0, 1, 0), u899(0, 100, 0) + t_v_411, 1 - v2860) * (v2894 - v2894.p)) * u902(0, 3, 0)) + v2894.p) + u899(0, (v2892 * v2888) / 16, 0);
               local v2896 = v2895;
               u932.CFrame = v2895;
               u958.weld.C0 = t_jointleg_396(1, 1.5, u958.hipcf, v2895:inverse() * u958.pos, ((v2860 * u923) / 5) * u958.angm) * u958.legcf;
               u959.weld.C0 = t_jointleg_396(1, 1.5, u959.hipcf, v2895:inverse() * (u959.pos + (((v2892 * v2888) / 3) * u899(0, 1, 0))), ((v2860 * u923) / 5) * u959.angm) * u959.legcf;
               local v2897 = u1007.p;
               local t_p_413 = v2897;
               u930.C0 = ((v2895:inverse() * t_direct_395(v2895 * u902(0, 0.825, 0), u922, v2884)) * u913(0, 0, (1 - v2897) * u939)) * u902(0, 0.675, 0);
               if (u1008) then
                  u1008.Brightness = u1009.p;
               end
               if (u936) then
                  local v2898 = u937;
                  if (v2898 == "gun") then
                     local v2899 = t_interpolate_392(u949, u913(v2893 / 10, v2893 * u958.torsoswing, 0) * t_interpolate_392(u944, ((((v2896:inverse() * t_direct_395(v2896 * t_interpolate_392(u948, u947, t_p_413), u922, v2884)) * u945) * u902(u1010.p)) * u924.fromaxisangle(u1011.p)) * u946, t_p_406), t_p_412);
                     u1012.C0 = t_jointarm_397(1, 1.5, u925, v2899 * u950) * u903;
                     u1013.C0 = t_jointarm_397(1, 1.5, u926, v2899 * u951) * u903;
                     u1014.C0 = v2899;
                  else
                     local v2900 = u937;
                     if (v2900 == "KNIFE") then
                        local v2901 = t_interpolate_392(u949, t_interpolate_392(u944, (((v2896:inverse() * t_direct_395(v2896 * u947, u922, v2884)) * u945) * u946) * t_interpolate_392(u898, u953, u1015.p), t_p_406), t_p_412);
                        if (u938) then
                           u1012.C0 = t_jointarm_397(1, 1.5, u925, v2901 * u950) * u903;
                        else
                           u1012.C0 = t_jointarm_397(1, 1.5, u925, u950) * u903;
                        end
                        u1013.C0 = t_jointarm_397(1, 1.5, u926, v2901 * u951) * u903;
                        u1014.C0 = v2901;
                     end
                  end
               end
            end
         end
         debug.profileend();
      end;
      v2770.step = f_step;
      local u1016 = p440;
      local u1017 = v2770;
      local f_updatestate;
      f_updatestate = function(p457)
         --[[
            Name: updatestate
            Upvalues: 
               1 => u927
               2 => u1016
               3 => u1017
               4 => f_gunrequire
               5 => t_FindFirstChild_391
               6 => u928
   
         --]]
         if (p457.healthstate) then
            u927.updatehealth(u1016, p457.healthstate);
         end
         if (p457.character) then
            u1017.updatecharacter(p457.character);
         end
         if (p457.lookangles) then
            u1017.setlookangles(p457.lookangles);
         end
         if (p457.stance) then
            u1017.setstance(p457.stance);
         end
         if (p457.sprint) then
            u1017.setsprint(p457.sprint);
         end
         if (p457.aim) then
            u1017.setaim(p457.aim);
         end
         if (p457.weapon) then
            local v2902 = f_gunrequire(p457.weapon);
            local v2903 = v2902;
            local v2904 = t_FindFirstChild_391(u928, p457.weapon);
            local v2905 = v2904;
            if (v2902 and v2904) then
               local t_type_415 = v2903.type;
               if (t_type_415 == "KNIFE") then
                  u1017.equipknife(v2903, v2905);
                  return;
               end
               u1017.equip(v2903, v2905);
               return;
            end
            print("Couldn't find a 3rd person weapon");
         end
      end;
      v2770.updatestate = f_updatestate;
      u929:send("state", p440);
      return v2770;
   end;
   local u1018 = v2654;
   local f_loadplayer = f_loadplayer;
   local f_getupdater;
   f_getupdater = function(p458)
      --[[
         Name: getupdater
         Upvalues: 
            1 => u1018
            2 => f_loadplayer
   
      --]]
      if (u1018[p458]) then
         if (u1018[p458]) then
            return u1018[p458].updater;
         end
      else
         local v2906 = f_loadplayer(p458);
         local v2907 = v2906;
         if (v2906) then
            local v2908 = u1018;
            local v2909 = {};
            v2909.updater = v2907;
            v2909.lastupdate = 0;
            v2909.lastlevel = 0;
            v2909.lastupframe = 0;
            v2908[p458] = v2909;
            local v2910 = v2907;
            return;
         end
      end
   end;
   v10.getupdater = f_getupdater;
   local f_getupdater = f_getupdater;
   v18:add("state", function(p459, p460)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2911 = f_getupdater(p459);
      local v2912 = v2911;
      if (v2911) then
         v2912.updatestate(p460);
      end
   end);
   local f_getupdater = f_getupdater;
   v18:add("stance", function(p461, p462)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2913 = f_getupdater(p461);
      local v2914 = v2913;
      if (v2913) then
         v2914.setstance(p462);
      end
   end);
   local f_getupdater = f_getupdater;
   v18:add("sprint", function(p463, p464)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2915 = f_getupdater(p463);
      local v2916 = v2915;
      if (v2915) then
         v2916.setsprint(p464);
      end
   end);
   local f_getupdater = f_getupdater;
   v18:add("lookangles", function(p465, p466)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2917 = f_getupdater(p465);
      local v2918 = v2917;
      if (v2917) then
         v2918.setlookangles(p466);
      end
   end);
   local f_getupdater = f_getupdater;
   v18:add("aim", function(p467, p468)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2919 = f_getupdater(p467);
      local v2920 = v2919;
      if (v2919) then
         v2920.setaim(p468);
      end
   end);
   local f_getupdater = f_getupdater;
   v18:add("stab", function(p469)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2921 = f_getupdater(p469);
      local v2922 = v2921;
      if (v2921) then
         v2922.stab();
      end
   end);
   local f_getupdater = f_getupdater;
   v18:add("updatecharacter", function(p470, p471)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
   
      --]]
      local v2923 = f_getupdater(p470);
      local v2924 = v2923;
      if (v2923) then
         v2924.updatecharacter(p471);
      end
   end);
   local f_getupdater = f_getupdater;
   local t_FindFirstChild_416 = v2648;
   local u1019 = v2657;
   v18:add("equipknife", function(p472, p473, p474)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
            2 => f_gunrequire
            3 => t_FindFirstChild_416
            4 => u1019
   
      --]]
      local v2925 = f_getupdater(p472);
      local v2926 = v2925;
      if (v2925) then
         local v2927 = f_gunrequire(p473);
         local v2928 = v2927;
         local v2929 = t_FindFirstChild_416(u1019, p473);
         local v2930 = v2929;
         if (v2927 and v2929) then
            v2926.equipknife(v2928, v2930, p474);
            return;
         end
         v2926.equipknife(nil);
      end
   end);
   local f_getupdater = f_getupdater;
   local t_FindFirstChild_417 = v2648;
   local u1020 = v2657;
   v18:add("equip", function(p475, p476, p477, p478)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_getupdater
            2 => f_gunrequire
            3 => t_FindFirstChild_417
            4 => u1020
   
      --]]
      local v2931 = f_getupdater(p475);
      local v2932 = v2931;
      if (v2931) then
         local v2933 = f_gunrequire(p476);
         local v2934 = v2933;
         local v2935 = t_FindFirstChild_417(u1020, p476);
         local v2936 = v2935;
         if (v2933 and v2935) then
            v2932.equip(v2934, v2936, p477, p478);
            return;
         end
         v2932.equip(nil);
      end
   end);
   local u1021 = v35;
   local u1022 = v7;
   local f_hiteffects;
   f_hiteffects = function(p479, p480, p481, p482)
      --[[
         Name: hiteffects
         Upvalues: 
            1 => u1021
            2 => u1022
   
      --]]
      u1021:bloodhit(p479, true, p481, p480.unit * 50);
      if (p482) then
         u1022:firehitmarker();
      end
   end;
   local v2937 = {};
   local u1023 = v30;
   local u1024 = v41;
   local u1025 = v2642;
   local t_LocalPlayer_418 = v2655;
   local u1026 = v7;
   local f_getupdater = f_getupdater;
   local u1027 = v2635;
   local u1028 = v12;
   local f_hiteffects = f_hiteffects;
   v2937.Frag = function(p483, p484, p485, p486)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1023
            2 => u1024
            3 => u1025
            4 => t_LocalPlayer_418
            5 => u1026
            6 => f_getupdater
            7 => u1027
            8 => u1028
            9 => f_hiteffects
   
      --]]
      local t_range0_419 = p483.range0;
      local t_range1_420 = p483.range1;
      local t_damage0_421 = p483.damage0;
      local t_damage1_422 = p483.damage1;
      local v2938 = (u1023.basecframe.p - p485).magnitude;
      local t_magnitude_423 = v2938;
      p484.Position = p485;
      if (v2938 <= 50) then
         u1024.play("fragClose", 2, 1, p484, true);
      else
         if (t_magnitude_423 <= 200) then
            u1024.play("fragMed", 3, 1, p484, true);
         else
            if (t_magnitude_423 > 200) then
               u1024.play("fragFar", 3, 1, p484, true);
            end
         end
      end
      local v2939 = u1025("Explosion");
      v2939.Position = p485;
      v2939.BlastRadius = p483.blastradius;
      v2939.BlastPressure = 0;
      v2939.DestroyJointRadiusPercent = 0;
      v2939.Parent = workspace;
      local g_next_424 = next;
      local v2940, v2941 = game:GetService("Players"):GetPlayers();
      local v2942 = v2940;
      local v2943 = v2941;
      while true do
         local v2944, v2945 = g_next_424(v2942, v2943);
         local v2946 = v2944;
         local v2947 = v2945;
         if (v2944) then
            v2943 = v2946;
            local v2948 = v2947.TeamColor;
            local t_TeamColor_425 = t_LocalPlayer_418.TeamColor;
            if ((not (v2948 == t_TeamColor_425)) and u1026:isplayeralive(v2947)) then
               local v2949 = f_getupdater(v2947).getpos();
               local v2950 = v2949;
               if (v2949) then
                  local v2951 = v2950 - p485;
                  local v2952 = v2951;
                  local v2953 = v2951.magnitude;
                  local t_magnitude_426 = v2953;
                  if ((v2953 < t_range1_420) and (not workspace:FindPartOnRayWithWhitelist(u1027(p485, v2951), u1028.raycastwhitelist, true))) then
                     local v2954 = false;
                     local v2955;
                     if (t_magnitude_426 < t_range0_419) then
                        v2955 = t_damage0_421;
                        if (not v2955) then
                           v2954 = true;
                        end
                     else
                        v2954 = true;
                     end
                     if (v2954) then
                        local v2956 = false;
                        if (t_magnitude_426 < t_range1_420) then
                           v2955 = (((t_damage1_422 - t_damage0_421) / (t_range1_420 - t_range0_419)) * (t_magnitude_426 - t_range0_419)) + t_damage0_421;
                           if (not v2955) then
                              v2956 = true;
                           end
                        else
                           v2956 = true;
                        end
                        if (v2956) then
                           v2955 = t_damage1_422;
                        end
                     end
                     f_hiteffects(v2950, v2952, v2955, p486);
                  end
               end
            end
         else
            break;
         end
      end
   end;
   local t_FindFirstChild_427 = v2648;
   local t_LocalPlayer_428 = v2655;
   local u1029 = v2661;
   local u1030 = v2937;
   local u1031 = v23;
   local u1032 = v35;
   local u1033 = v2631;
   local u1034 = v2635;
   local u1035 = v30;
   local u1036 = v12;
   v18:add("newgrenade", function(p487, p488, p489)
      --[[
         Name: (empty)
         Upvalues: 
            1 => f_gunrequire
            2 => t_getGunModel_3
            3 => t_FindFirstChild_427
            4 => t_LocalPlayer_428
            5 => u1029
            6 => u1030
            7 => u1031
            8 => u1032
            9 => u1033
            10 => u1034
            11 => u1035
            12 => u1036
   
      --]]
      local v2957 = f_gunrequire(p488);
      local v2958 = t_getGunModel_3(p488).Trigger:Clone();
      local v2959 = v2958;
      local v2960 = t_FindFirstChild_427(v2958, "Indicator");
      local v2961 = p487 == t_LocalPlayer_428;
      local v2962 = v2961;
      if (v2961) then
         v2959.Transparency = 1;
      else
         v2959.Trail.Enabled = true;
         if (v2960) then
            local v2963 = p487.TeamColor;
            local t_TeamColor_431 = t_LocalPlayer_428.TeamColor;
            if (v2963 == t_TeamColor_431) then
               v2960.Friendly.Visible = true;
            else
               v2960.Enemy.Visible = true;
            end
         end
      end
      v2959.Anchored = true;
      v2959.Ticking:Play();
      v2959.Parent = u1029.Misc;
      local u1037 = v2957;
      local u1038 = v2959;
      local u1039 = v2962;
      local f_explode;
      f_explode = function(p490)
         --[[
            Name: explode
            Upvalues: 
               1 => u1030
               2 => u1037
               3 => u1038
               4 => u1039
   
         --]]
         local v2964 = false;
         local v2965 = u1030;
         local v2966;
         if (u1037.grenadetype and u1030[u1037.grenadetype]) then
            v2966 = u1037.grenadetype;
            if (not v2966) then
               v2964 = true;
            end
         else
            v2964 = true;
         end
         if (v2964) then
            v2966 = "Frag";
         end
         v2965[v2966](u1037, u1038, p490, u1039);
         u1038:Destroy();
      end;
      local v2967 = p489.time;
      local v2968 = v2967 - tick();
      local u1040 = v2967;
      local u1041 = 1;
      local u1042 = nil;
      local v2969 = game:GetService("RunService").RenderStepped;
      local u1043 = v2968;
      local t_time_429 = v2967;
      local u1044 = p489;
      local u1045 = v2959;
      local u1046 = v2962;
      local u1047 = v2960;
      local f_explode = f_explode;
      u1042 = v2969:connect(function(p491)
         --[[
            Name: (empty)
            Upvalues: 
               1 => u1043
               2 => t_time_429
               3 => u1044
               4 => u1045
               5 => u1041
               6 => u1046
               7 => u1031
               8 => u1040
               9 => u1032
               10 => u1033
               11 => u1047
               12 => u1034
               13 => u1035
               14 => u1036
               15 => f_explode
               16 => u1042
   
         --]]
         local v2970 = tick();
         local v2971 = v2970 + ((u1043 * ((t_time_429 + u1044.blowuptime) - v2970)) / (u1044.blowuptime + u1043));
         if (u1045 and u1044) then
            local v2972 = u1044.frames;
            local v2973 = v2972[u1041];
            local v2974 = v2972[u1041 + 1];
            local v2975 = v2974;
            if (v2974 and ((t_time_429 + v2975.t0) < v2971)) then
               u1041 = u1041 + 1;
               v2973 = v2975;
            end
            local v2976 = v2971 - (t_time_429 + v2973.t0);
            local v2977 = v2976;
            local v2978 = ((v2973.p0 + (v2976 * v2973.v0)) + (((v2976 * v2976) / 2) * v2973.a)) + v2973.offset;
            if (not u1046) then
               local v2979 = u1031.fromaxisangle(v2977 * v2973.rotv) * v2973.rot0;
               local v2980 = v2973.glassbreaks;
               local t_glassbreaks_430 = v2980;
               local v2981 = 1;
               local v2982 = #v2980;
               local v2983 = v2982;
               local v2984 = v2981;
               if (not (v2982 <= v2984)) then
                  while true do
                     local v2985 = t_glassbreaks_430[v2981];
                     local v2986 = v2985;
                     if (v2985.part) then
                        local v2987 = u1040;
                        local v2988 = t_time_429 + v2986.t;
                        if ((v2987 < v2988) and ((t_time_429 + v2986.t) <= v2971)) then
                           u1032:breakwindow(v2986.part, nil, nil, u1033());
                        end
                     end
                     local v2989 = v2981 + 1;
                     v2981 = v2989;
                     local v2990 = v2983;
                     if (v2990 < v2989) then
                        break;
                     end
                  end
               end
               u1045.CFrame = v2979 + v2978;
               if (u1047) then
                  u1047.Enabled = not workspace:FindPartOnRayWithWhitelist(u1034(v2978, u1035.cframe.p - v2978), u1036.raycastwhitelist, true);
               end
            end
            if ((t_time_429 + u1044.blowuptime) <= v2971) then
               f_explode(v2978);
               u1042:Disconnect();
            end
         end
         u1040 = v2971;
      end);
   end);
   local u1048 = 1.25;
   local u1049 = os.clock();
   local f_suppressionmult;
   f_suppressionmult = function()
      --[[
         Name: suppressionmult
         Upvalues: 
            1 => u1049
            2 => u1048
   
      --]]
      return (((2.718281828459045) ^ ((-(os.clock() - u1049)) / 1)) * (1.25 - u1048)) + u1048;
   end;
   local f_normalizesuppression;
   f_normalizesuppression = function()
      --[[
         Name: normalizesuppression
         Upvalues: 
            1 => f_suppressionmult
            2 => u1048
            3 => u1049
   
      --]]
      u1048 = ((f_suppressionmult() - 0.5) / 1.133148453066826) + 0.5;
      u1049 = os.clock();
   end;
   local t_LocalPlayer_432 = v2655;
   local u1050 = v2659;
   local u1051 = v30;
   local f_getupdater = f_getupdater;
   local u1052 = v2636;
   local u1053 = v2637;
   local u1054 = v7;
   local u1055 = v34;
   local u1056 = v14;
   local t_Dot_433 = v2633;
   local u1057 = v18;
   local u1058 = v41;
   local u1059 = v21;
   local u1060 = v2660;
   local u1061 = v35;
   local u1062 = v2631;
   v18:add("newbullets", function(p492)
      --[[
         Name: (empty)
         Upvalues: 
            1 => t_LocalPlayer_432
            2 => u1050
            3 => u1051
            4 => f_getupdater
            5 => u1052
            6 => u1053
            7 => u1054
            8 => u1055
            9 => u1056
            10 => t_Dot_433
            11 => f_suppressionmult
            12 => u1057
            13 => u1058
            14 => u1059
            15 => f_normalizesuppression
            16 => u1060
            17 => u1061
            18 => u1062
   
      --]]
      local v2991 = nil;
      local v2992 = p492.player;
      local t_player_434 = v2992;
      local t_hideflash_435 = p492.hideflash;
      local t_hideminimap_436 = p492.hideminimap;
      local t_hiderange_437 = p492.hiderange;
      local t_pingdata_438 = p492.pingdata;
      local t_snipercrack_439 = p492.snipercrack;
      local t_firepos_440 = p492.firepos;
      local t_pitch_441 = p492.pitch;
      local t_volume_442 = p492.volume;
      local t_bullets_443 = p492.bullets;
      local t_bulletcolor_444 = p492.bulletcolor;
      local t_penetrationdepth_445 = p492.penetrationdepth;
      local t_suppression_446 = p492.suppression;
      local v2993 = v2992.TeamColor ~= t_LocalPlayer_432.TeamColor;
      local v2994 = {
         u1050,
         workspace.Terrain,
         workspace.Ignore,
         u1051.currentcamera
      };
      local v2995 = f_getupdater(v2992);
      local v2996 = v2995;
      if (v2995) then
         v2996.kickweapon(t_hideflash_435, t_pitch_441, t_volume_442);
         v2991 = v2996:getweaponpos();
      end
      if (not (t_hideminimap_436 and (not (t_hideminimap_436 and ((t_firepos_440 - u1051.cframe.p).Magnitude < t_hiderange_437))))) then
         local v2997 = v2996.getlookangles();
         local v2998 = u1052(t_firepos_440) * u1053(v2997.x, v2997.y, 0);
         local v2999 = v2998;
         if (v2998) then
            u1054:fireradar(t_player_434, t_hideminimap_436, t_pingdata_438, v2999);
         end
      end
      local u1063 = false;
      local v3000 = 1;
      local v3001 = #t_bullets_443;
      local v3002 = v3001;
      local v3003 = v3000;
      if (not (v3001 <= v3003)) then
         while true do
            local v3004 = t_bullets_443[v3000];
            local t_new_447 = u1055.new;
            local v3005 = {};
            v3005.position = t_firepos_440;
            v3005.velocity = v3004;
            v3005.acceleration = u1056.bulletAcceleration;
            v3005.physicsignore = v2994;
            v3005.color = t_bulletcolor_444;
            v3005.size = 0.2;
            v3005.bloom = 0.005;
            v3005.brightness = 400;
            v3005.life = u1056.bulletLifeTime;
            v3005.visualorigin = v2991;
            v3005.penetrationdepth = t_penetrationdepth_445;
            v3005.thirdperson = true;
            local v3006 = v2993;
            if (v3006) then
               local u1064 = t_suppression_446;
               local u1065 = t_player_434;
               local u1066 = t_snipercrack_439;
               v3006 = function(p493, p494)
                  --[[
                     Name: (empty)
                     Upvalues: 
                        1 => u1051
                        2 => t_Dot_433
                        3 => f_suppressionmult
                        4 => u1064
                        5 => u1057
                        6 => u1065
                        7 => u1066
                        8 => u1058
                        9 => u1063
                        10 => u1059
                        11 => f_normalizesuppression
   
                  --]]
                  local v3007 = p493.velocity;
                  local t_velocity_448 = v3007;
                  local v3008 = p494 * v3007;
                  local v3009 = v3008;
                  local v3010 = p493.position - v3008;
                  local v3011 = v3010;
                  local v3012 = u1051.cframe.p;
                  local t_p_449 = v3012;
                  local v3013 = t_Dot_433(v3012 - v3010, v3008) / t_Dot_433(v3008, v3008);
                  if ((v3013 > 0) and (v3013 < 1)) then
                     local v3014 = ((v3011 + (v3013 * v3009)) - t_p_449).magnitude;
                     local t_magnitude_450 = v3014;
                     local v3015 = f_suppressionmult() * u1064;
                     local v3016;
                     if (v3014 < 2) then
                        v3016 = 2;
                     else
                        v3016 = t_magnitude_450;
                     end
                     local v3017 = (v3015 / (512 * v3016)) * t_velocity_448.magnitude;
                     local v3018 = v3017;
                     u1057:send("suppressionassist", u1065, v3017);
                     if (t_magnitude_450 < 50) then
                        if (u1066) then
                           u1058.PlaySound("crackBig", nil, 8 / t_magnitude_450);
                        else
                           if (t_magnitude_450 <= 5) then
                              u1058.PlaySound("crackSmall", nil, 2);
                           else
                              u1058.PlaySound("whizz", nil, 2 / t_magnitude_450);
                           end
                        end
                        if ((not u1063) and (t_magnitude_450 < 15)) then
                           u1063 = true;
                           u1057:send("updatecombat");
                        end
                     end
                     u1051:suppress(u1059.random(v3018, v3018));
                     f_normalizesuppression();
                  end
               end;
            end
            v3005.onstep = v3006;
            v3005.ontouch = function(p495, p496, p497, p498, p499, p500)
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u1060
                     2 => u1061
                     3 => u1062
                     4 => u1050
   
               --]]
               if (p496:IsDescendantOf(u1060)) then
                  u1061:bullethit(p496, p497, p498, p499, p500, u1062(), true, true);
                  return;
               end
               if (p496:IsDescendantOf(u1050)) then
                  u1061:bloodhit(p497, true, nil, p495.velocity / 10, true);
               end
            end;
            t_new_447(v3005);
            local v3019 = v3000 + 1;
            v3000 = v3019;
            local v3020 = v3002;
            if (v3020 < v3019) then
               break;
            end
         end
      end
   end);
   local u1067 = nil;
   local u1068 = 2;
   local u1069 = 1;
   local f_sethighms;
   f_sethighms = function(p501)
      --[[
         Name: sethighms
         Upvalues: 
            1 => u1068
   
      --]]
      u1068 = p501;
   end;
   v10.sethighms = f_sethighms;
   local f_setlowms;
   f_setlowms = function(p502)
      --[[
         Name: setlowms
         Upvalues: 
            1 => u1069
   
      --]]
      u1069 = p502;
   end;
   v10.setlowms = f_setlowms;
   local u1070 = 0;
   local u1071 = 0;
   local v3021 = table.create(game:GetService("Players").MaxPlayers);
   local v3022 = table.create(game:GetService("Players").MaxPlayers);
   local v3023 = coroutine.create;
   local u1072 = v3022;
   local u1073 = v2630;
   local u1074 = v28;
   local u1075 = v2629;
   local v3024 = v3023(function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1072
            2 => u1070
            3 => u1071
            4 => u1073
            5 => u1074
            6 => u1075
   
      --]]
      while true do
         local v3025 = u1072[1].lastupframe;
         local v3026 = u1070;
         if (v3025 == v3026) then
            coroutine.yield(true);
         else
            local v3027 = u1071;
            local v3028 = tick();
            if (v3027 < v3028) then
               coroutine.yield(true);
            end
         end
         local v3029 = u1073(u1072, 1);
         local v3030 = v3029;
         local v3031 = v3029.updater;
         local t_updater_451 = v3031;
         if (v3031.alive) then
            local v3032 = false;
            if (t_updater_451) then
               local v3033, v3034 = t_updater_451.getpos();
               local v3035 = v3033;
               local v3036 = v3034;
               if (v3033 and v3034) then
                  local v3037 = u1074.sphere(v3035, 4);
                  if (not v3037) then
                     v3037 = u1074.sphere(v3036, 4);
                  end
                  v3032 = v3037;
               end
            end
            if (v3032) then
               t_updater_451.step(3, true);
            else
               t_updater_451.step(1, false);
            end
         end
         v3030.lastupframe = u1070;
         u1075(u1072, v3030);
      end
   end);
   local u1076 = v2654;
   local u1077 = v3021;
   local u1078 = v3022;
   local u1079 = v2629;
   local u1080 = v2630;
   local f_removecharacterhash = f_removecharacterhash;
   local u1081 = v3024;
   local u1082 = v18;
   local f_resumerep;
   f_resumerep = function()
      --[[
         Name: resumerep
         Upvalues: 
            1 => u1076
            2 => u1077
            3 => u1078
            4 => u1079
            5 => u1080
            6 => f_removecharacterhash
            7 => u1070
            8 => u1071
            9 => u1069
            10 => u1068
            11 => u1081
            12 => u1067
            13 => u1082
   
      --]]
      local g_next_452 = next;
      local v3038 = u1076;
      local v3039 = nil;
      while true do
         local v3040, v3041 = g_next_452(v3038, v3039);
         local v3042 = v3040;
         local v3043 = v3041;
         if (v3040) then
            v3039 = v3042;
            if (v3042.Parent) then
               if ((v3043 and v3043.updater) and (not u1077[v3043])) then
                  u1077[v3043] = true;
                  u1079(u1078, v3043);
               end
            else
               print("PLAYER IS GONE", v3042);
               local v3044 = 1;
               local v3045 = #u1078;
               local v3046 = v3045;
               local v3047 = v3044;
               if (not (v3045 <= v3047)) then
                  while true do
                     if (u1078[v3044] == v3043) then
                        warn("Updater was in queue", v3042);
                        u1080(u1078, v3044);
                     end
                     local v3048 = v3044 + 1;
                     v3044 = v3048;
                     local v3049 = v3046;
                     if (v3049 < v3048) then
                        break;
                     end
                  end
               end
               if (v3043 and v3043.updater) then
                  local v3050 = v3043.updater;
                  local t_updater_453 = v3050;
                  local v3051, v3052, v3053 = pairs(v3050);
                  local v3054 = v3051;
                  local v3055 = v3052;
                  local v3056 = v3053;
                  while true do
                     local v3057, v3058 = v3054(v3055, v3056);
                     local v3059 = v3057;
                     if (v3057) then
                        v3056 = v3059;
                        t_updater_453[v3059] = nil;
                     else
                        break;
                     end
                  end
               end
               u1076[v3042] = nil;
               u1077[v3043] = nil;
               f_removecharacterhash(v3042);
            end
         else
            break;
         end
      end
      u1070 = u1070 + 1;
      u1071 = tick() + ((u1069 + u1068) / 1000);
      local v3060 = #u1078;
      if (v3060 > 0) then
         local v3061, v3062 = coroutine.resume(u1081);
         local v3063 = v3062;
         if (not v3061) then
            warn("CRITICAL: Replication thread yielded or errored");
            if (not u1067) then
               u1067 = true;
               u1082:send("debug", string.format("Replication thread broke.\n%s", v3063));
            end
         end
      end
   end;
   local u1083 = v5;
   local u1084 = v30;
   local u1085 = v2631;
   local u1086 = v18;
   local f_replicationupdate;
   f_replicationupdate = function()
      --[[
         Name: replicationupdate
         Upvalues: 
            1 => u877
            2 => u1083
            3 => u1084
            4 => u1085
            5 => u1086
   
      --]]
      local v3064 = tick();
      if ((u877 <= v3064) and u1083.alive) then
         u877 = (v3064 + 0.01666666666666667) - ((v3064 - u877) % 0.01666666666666667);
         local v3065 = u1084.angles;
         u1086:send("repupdate", u1083.rootpart.Position + u1085(0, u1083.headheight, 0), Vector2.new(v3065.x, v3065.y));
      end
   end;
   local f_replicationupdate = f_replicationupdate;
   local f_step;
   f_step = function()
      --[[
         Name: step
         Upvalues: 
            1 => f_resumerep
            2 => f_replicationupdate
   
      --]]
      f_resumerep();
      f_replicationupdate();
   end;
   v10.step = f_step;
   local u1087 = v2653;
   local f_cleanup;
   f_cleanup = function()
      --[[
         Name: cleanup
         Upvalues: 
            1 => u1087
   
      --]]
      local v3066 = 1;
      local v3067 = #u1087;
      local v3068 = v3067;
      local v3069 = v3066;
      if (not (v3067 <= v3069)) then
         while true do
            u1087[v3066]:Destroy();
            u1087[v3066] = nil;
            local v3070 = v3066 + 1;
            v3066 = v3070;
            local v3071 = v3068;
            if (v3071 < v3070) then
               break;
            end
         end
      end
   end;
   v10.cleanup = f_cleanup;
   v20.Reset:connect(v10.cleanup);
   print("Requiring menu module");
   local v3072 = require(script.Parent.UIScript);
   local v3073 = {};
   v3073.superuser = v3;
   v3073.uiscaler = v38;
   v3073.vector = v21;
   v3073.cframe = v23;
   v3073.network = v18;
   v3073.playerdata = v4;
   v3073.effects = v35;
   v3073.animation = v32;
   v3073.input = v33;
   v3073.char = v5;
   v3073.camera = v30;
   v3073.chat = v6;
   v3073.hud = v7;
   v3073.leaderboard = v9;
   v3073.replication = v10;
   v3073.menu = v11;
   v3073.roundsystem = v12;
   v3073.gamelogic = v13;
   v3073.instancetype = v40;
   v3072(v3073);
   print("Requiring unlockstats module");
   local v3074 = require(script.Parent.UnlockStats);
   local v3075 = {};
   v3075.vector = v21;
   v3075.cframe = v23;
   v3075.network = v18;
   v3075.playerdata = v4;
   v3075.event = v26;
   v3075.sequencer = v31;
   v3075.particle = v34;
   v3075.sound = v41;
   v3075.effects = v35;
   v3075.tween = v36;
   v3075.animation = v32;
   v3075.input = v33;
   v3075.char = v5;
   v3075.camera = v30;
   v3075.chat = v6;
   v3075.hud = v7;
   v3075.notify = v8;
   v3075.leaderboard = v9;
   v3075.replication = v10;
   v3075.menu = v11;
   v3075.roundsystem = v12;
   v3075.gamelogic = v13;
   v3074(v3075);
   print("Loading roundsystem module client");
   local v3076 = shared.require("ObjectiveManagerClient");
   local v3077 = game.IsA;
   local v3078 = Instance.new;
   local v3079 = game.WaitForChild;
   local v3080 = game.FindFirstChild;
   local v3081 = game.GetChildren;
   local v3082 = CFrame.new;
   local v3083 = CFrame.Angles;
   local v3084 = UDim2.new;
   local v3085 = Color3.new;
   local v3086 = BrickColor.new;
   local v3087 = Vector3.new;
   local v3088 = game:GetService("GuiService");
   local v3089 = Ray.new;
   local v3090 = workspace.Map;
   local v3091 = workspace.FindPartOnRayWithIgnoreList;
   local v3092 = v3079(v3079(game, "ReplicatedStorage"), "ServerSettings");
   local v3093 = v3079(v3092, "Countdown");
   local v3094 = v3079(v3092, "Timer");
   local v3095 = v3094;
   local v3096 = v3079(v3092, "MaxScore");
   local v3097 = v3079(v3092, "GhostScore");
   local v3098 = v3097;
   local v3099 = v3079(v3092, "PhantomScore");
   local v3100 = v3099;
   local v3101 = v3079(v3092, "ShowResults");
   local v3102 = v3101;
   local v3103 = v3079(v3092, "Quote");
   local v3104 = v3079(v3092, "Winner");
   local v3105 = v3079(v3092, "GameMode");
   local v3106 = game:GetService("Players").LocalPlayer;
   local v3107 = v3079(v3079(v3106, "PlayerGui"), "MainGui");
   local v3108 = v3079(v3107, "CountDown");
   local v3109 = v3079(v3108, "TeamName");
   local v3110 = v3079(v3108, "Title");
   local v3111 = v3079(v3108, "Number");
   local v3112 = v3079(v3108, "Tip");
   local v3113 = v3079(v3079(v3107, "GameGui"), "Round");
   local v3114 = v3079(v3113, "Score");
   local v3115 = v3079(v3113, "GameMode");
   local v3116 = v3079(v3114, "Ghosts");
   local v3117 = v3079(v3114, "Phantoms");
   local v3118 = v3079(v3114, "Time");
   local v3119 = v3079(v3107, "EndMatch");
   local v3120 = v3079(v3119, "Quote");
   local v3121 = v3079(v3119, "Result");
   local v3122 = v3079(v3119, "Mode");
   v12.lock = false;
   v12.raycastwhitelist = {
      v3090
   };
   local u1088 = v3087();
   local u1089 = nil;
   local v3123 = {};
   local t_FindFirstChild_454 = v3080;
   local u1090 = v3087;
   local f_updatekillzone;
   f_updatekillzone = function(p503, p504)
      --[[
         Name: updatekillzone
         Upvalues: 
            1 => t_FindFirstChild_454
            2 => u1089
            3 => u1088
            4 => u1090
   
      --]]
      local v3124 = t_FindFirstChild_454(p504, "Killzone");
      local v3125 = v3124;
      u1089 = false;
      if (v3124) then
         u1088 = v3125.Position;
         return;
      end
      u1088 = u1090();
   end;
   v12.updatekillzone = f_updatekillzone;
   local u1091 = nil;
   local u1092 = v3076;
   local f_setupobjectives;
   f_setupobjectives = function(p505)
      --[[
         Name: setupobjectives
         Upvalues: 
            1 => u1092
            2 => u1091
   
      --]]
      u1092:clear();
      if (u1091) then
         u1091:Disconnect();
      end
      local v3126 = p505:FindFirstChild("AGMP");
      local v3127 = v3126;
      if (v3126) then
         local g_next_455 = next;
         local v3128, v3129 = v3127:GetChildren();
         local v3130 = v3128;
         local v3131 = v3129;
         while true do
            local v3132, v3133 = g_next_455(v3130, v3131);
            local v3134 = v3132;
            local v3135 = v3133;
            if (v3132) then
               v3131 = v3134;
               u1092:add(v3135);
            else
               break;
            end
         end
         u1091 = v3127.ChildAdded:connect(function(p506)
            --[[
               Name: (empty)
               Upvalues: 
                  1 => u1092
   
            --]]
            u1092:add(p506);
         end);
      end
   end;
   v18:add("newmap", f_setupobjectives);
   f_setupobjectives(v3090);
   local u1093 = v18;
   local f_checkkillzone;
   f_checkkillzone = function(p507, p508, p509)
      --[[
         Name: checkkillzone
         Upvalues: 
            1 => u1088
            2 => u1089
            3 => u1093
   
      --]]
      local v3136 = p509.Y;
      local t_Y_456 = u1088.Y;
      if ((v3136 < t_Y_456) and (not u1089)) then
         u1089 = true;
         u1093:send("falldamage", 1000);
      end
   end;
   v12.checkkillzone = f_checkkillzone;
   local u1094 = v11;
   local f_spawnplayer;
   f_spawnplayer = function()
      --[[
         Name: spawnplayer
         Upvalues: 
            1 => u1094
   
      --]]
      u1094:roundstartspawn();
   end;
   local u1095 = v3115;
   local u1096 = v3105;
   local t_LocalPlayer_457 = v3106;
   local u1097 = v3116;
   local u1098 = v3084;
   local u1099 = v3117;
   local f_updateteam;
   f_updateteam = function(p510)
      --[[
         Name: updateteam
         Upvalues: 
            1 => u1095
            2 => u1096
            3 => t_LocalPlayer_457
            4 => u1097
            5 => u1098
            6 => u1099
   
      --]]
      u1095.Text = u1096.Value;
      local v3137 = t_LocalPlayer_457.TeamColor;
      local t_TeamColor_458 = game.Teams.Phantoms.TeamColor;
      if (v3137 == t_TeamColor_458) then
         u1097.Position = u1098(0.5, -48, 0, 44);
         u1099.Position = u1098(0.5, -48, 0, 28);
         return;
      end
      u1099.Position = u1098(0.5, -48, 0, 44);
      u1097.Position = u1098(0.5, -48, 0, 28);
   end;
   v7.updateteam = f_updateteam;
   local u1100 = v3116;
   local u1101 = v3097;
   local u1102 = v3096;
   local u1103 = v3117;
   local u1104 = v3099;
   local f_updatescore;
   f_updatescore = function()
      --[[
         Name: updatescore
         Upvalues: 
            1 => u1100
            2 => u1101
            3 => u1102
            4 => u1103
            5 => u1104
   
      --]]
      local v3138 = UDim2.new;
      u1100.Percent.Size = v3138(u1101.Value / u1102.Value, 0, 1, 0);
      u1100.Point.Text = u1101.Value;
      u1103.Percent.Size = v3138(u1104.Value / u1102.Value, 0, 1, 0);
      u1103.Point.Text = u1104.Value;
   end;
   local u1105 = v12;
   local u1106 = v3112;
   local u1107 = v33;
   local u1108 = v5;
   local u1109 = v3109;
   local t_LocalPlayer_459 = v3106;
   local u1110 = v3108;
   local u1111 = v3111;
   local u1112 = v3094;
   local u1113 = v3110;
   local f_count;
   f_count = function()
      --[[
         Name: count
         Upvalues: 
            1 => u1105
            2 => u1106
            3 => u1107
            4 => u1108
            5 => u1109
            6 => t_LocalPlayer_459
            7 => u1110
            8 => u1111
            9 => u1112
            10 => u1113
   
      --]]
      u1105.lock = true;
      local v3139 = u1106;
      local v3140;
      if (u1107.consoleon) then
         v3140 = "Press ButtonSelect to return to menu";
      else
         v3140 = "Press F5 to return to menu";
      end
      v3139.Text = v3140;
      if (u1108.alive) then
         local v3141 = u1109;
         local v3142 = t_LocalPlayer_459.TeamColor;
         local t_TeamColor_460 = game.Teams.Ghosts.TeamColor;
         local v3143;
         if (v3142 == t_TeamColor_460) then
            v3143 = "Ghosts";
         else
            v3143 = "Phantoms";
         end
         v3141.Text = v3143;
         u1109.Visible = true;
         u1109.TextColor3 = t_LocalPlayer_459.TeamColor.Color;
         u1110.Visible = true;
         u1111.FontSize = 9;
         u1111.Text = u1112.Value;
         local v3144 = 9;
         local v3145 = v3144;
         if (not (v3145 <= 7)) then
            while true do
               u1111.FontSize = v3144;
               wait(0.03333333333333333);
               local v3146 = v3144 + -1;
               v3144 = v3146;
               if (v3146 < 7) then
                  break;
               end
            end
         end
         local t_Value_461 = u1112.Value;
         if (t_Value_461 == 0) then
            wait(1);
            u1105.lock = false;
            wait(2);
            u1110.Visible = false;
            return;
         end
         u1110.BackgroundTransparency = 0.5;
         u1111.TextTransparency = 0;
         u1113.TextTransparency = 0;
         u1113.TextStrokeTransparency = 0.5;
      end
   end;
   local u1114 = v3094;
   local u1115 = v3118;
   local f_matchclock;
   f_matchclock = function()
      --[[
         Name: matchclock
         Upvalues: 
            1 => u1114
            2 => u1115
   
      --]]
      local v3147 = u1114.Value % 60;
      if (v3147 < 10) then
         v3147 = "0" .. v3147;
      end
      u1115.Text = math.floor(u1114.Value / 60) .. (":" .. v3147);
   end;
   local u1116 = v3093;
   local u1117 = v3118;
   local f_count = f_count;
   local u1118 = v3101;
   local u1119 = v12;
   local u1120 = v3108;
   local f_matchclock = f_matchclock;
   local f_timerchange;
   f_timerchange = function()
      --[[
         Name: timerchange
         Upvalues: 
            1 => u1116
            2 => u1117
            3 => f_count
            4 => u1118
            5 => u1119
            6 => u1120
            7 => f_matchclock
   
      --]]
      if (u1116.Value) then
         u1117.Text = "COUNTDOWN";
         f_count();
         return;
      end
      if (not u1118.Value) then
         u1119.lock = false;
      end
      u1120.Visible = false;
      f_matchclock();
   end;
   local u1121 = v3101;
   local u1122 = v12;
   local u1123 = v3120;
   local u1124 = v3103;
   local u1125 = v3119;
   local u1126 = v3122;
   local u1127 = v3105;
   local u1128 = v3104;
   local t_LocalPlayer_462 = v3106;
   local u1129 = v3121;
   local u1130 = v3086;
   local f_setresult;
   f_setresult = function()
      --[[
         Name: setresult
         Upvalues: 
            1 => u1121
            2 => u1122
            3 => u1123
            4 => u1124
            5 => u1125
            6 => u1126
            7 => u1127
            8 => u1128
            9 => t_LocalPlayer_462
            10 => u1129
            11 => u1130
   
      --]]
      if (not u1121.Value) then
         u1125.Visible = false;
         return;
      end
      u1122.lock = true;
      u1123.Text = u1124.Value;
      u1125.Visible = true;
      u1126.Text = u1127.Value;
      local v3148 = u1128.Value;
      local t_TeamColor_463 = t_LocalPlayer_462.TeamColor;
      if (v3148 == t_TeamColor_463) then
         u1129.Text = "VICTORY";
         u1129.TextColor = u1130("Bright green");
         return;
      end
      local v3149 = u1128.Value;
      local v3150 = u1130("Black");
      if (v3149 == v3150) then
         u1129.Text = "STALEMATE";
         u1129.TextColor = u1130("Bright orange");
         return;
      end
      u1129.Text = "DEFEAT";
      u1129.TextColor = u1130("Bright red");
   end;
   if (v3093.Value) then
      f_count();
   end
   f_setresult();
   v3095.Changed:connect(f_timerchange);
   v3098.Changed:connect(f_updatescore);
   v3100.Changed:connect(f_updatescore);
   v3102.Changed:connect(f_setresult);
   f_updatescore();
   print("Loading game logic module");
   local v3151 = v5.loadknife;
   local v3152 = v5.loadgun;
   local v3153 = game.FindFirstChild;
   v5.loadknife = nil;
   v5.loadgun = nil;
   local v3154 = game.Debris;
   local v3155 = Instance.new;
   local v3156 = game.ReplicatedStorage;
   local v3157 = game:GetService("RunService");
   local v3158 = game:GetService("Players").LocalPlayer;
   local v3159 = v3158.PlayerGui;
   local v3160 = {};
   local u1131 = 1;
   local u1132 = nil;
   local u1133 = nil;
   local u1134 = nil;
   local u1135 = nil;
   local u1136 = nil;
   local u1137 = nil;
   local u1138 = nil;
   local u1139 = nil;
   local u1140 = nil;
   local u1141 = 0;
   v13.currentgun = nil;
   v13.gammo = 3;
   local f_setsprintdisable;
   f_setsprintdisable = function(p511)
      --[[
         Name: setsprintdisable
         Upvalues: 
            1 => u1138
   
      --]]
      u1138 = p511;
   end;
   v13.setsprintdisable = f_setsprintdisable;
   local u1142 = v13;
   local u1143 = v5;
   local u1144 = v3160;
   local f_switch;
   f_switch = function(p512)
      --[[
         Name: switch
         Upvalues: 
            1 => u1134
            2 => u1142
            3 => u1143
            4 => u1131
            5 => u1144
   
      --]]
      if (((not u1134) and u1142.currentgun) and (not u1143.grenadehold)) then
         local v3161;
         if (p512 == "one") then
            v3161 = 1;
         else
            if (p512 == "two") then
               v3161 = 2;
            else
               v3161 = (((u1131 + p512) - 1) % (#u1144)) + 1;
            end
         end
         u1131 = v3161;
         local v3162 = u1144[u1131];
         local v3163 = v3162;
         if (v3162) then
            local t_currentgun_464 = u1142.currentgun;
            if (v3163 ~= t_currentgun_464) then
               u1142.currentgun:setequipped(false);
               u1142.currentgun = v3163;
               v3163:setequipped(true);
               wait(0.4);
               u1134 = false;
            end
         end
      end
   end;
   local u1145 = v3160;
   local u1146 = v5;
   local t_ReplicatedStorage_465 = v3156;
   local t_loadgun_466 = v3152;
   local t_loadknife_467 = v3151;
   local u1147 = v13;
   local u1148 = v7;
   local u1149 = v11;
   local u1150 = v33;
   local u1151 = v6;
   local u1152 = v35;
   local u1153 = v30;
   local f_loadmodules;
   f_loadmodules = function(p513, p514, p515, p516, p517, p518, p519)
      --[[
         Name: loadmodules
         Upvalues: 
            1 => u1145
            2 => u1132
            3 => u1146
            4 => t_ReplicatedStorage_465
            5 => u1131
            6 => t_loadgun_466
            7 => t_loadknife_467
            8 => u1147
            9 => u1148
            10 => u1149
            11 => u1150
            12 => u1151
            13 => u1152
            14 => u1153
   
      --]]
      local v3164 = 1;
      local v3165 = #u1145;
      local v3166 = v3165;
      local v3167 = v3164;
      if (not (v3165 <= v3167)) then
         while true do
            local v3168 = u1145[v3164];
            local v3169 = v3168;
            if (v3168) then
               v3169:destroy("death");
               u1145[v3164] = nil;
            end
            local v3170 = v3164 + 1;
            v3164 = v3170;
            local v3171 = v3166;
            if (v3171 < v3170) then
               break;
            end
         end
      end
      if (u1132) then
         u1132:destroy();
      end
      u1146.loadcharacter(p513, p514);
      u1146:loadarms(t_ReplicatedStorage_465.Character["Left Arm"]:Clone(), t_ReplicatedStorage_465.Character["Right Arm"]:Clone(), "Arm", "Arm");
      u1131 = 1;
      u1145[1] = t_loadgun_466(p515.Name, false, false, p515.Attachments, p517, p515.Camo, 1);
      if (p516) then
         u1145[2] = t_loadgun_466(p516.Name, false, false, p516.Attachments, p518, p516.Camo, 2);
      end
      u1132 = t_loadknife_467(p519.Name or "KNIFE", p519.Camo);
      u1147.gammo = 3;
      u1148:updateammo("GRENADE", 3);
      u1149.hidemenu();
      u1149.setlighting();
      u1150.mouse.hide();
      u1150.mouse.lockcenter();
      u1148:updateteam();
      u1148:enablegamegui(true);
      u1148:set_minimap();
      u1151:ingame();
      u1152:enableshadows(u1152.shadows);
      u1152:enablemapshaders(not u1152.disableshaders);
      u1146.alive = true;
      u1153.type = "firstperson";
      u1147.currentgun = u1145[u1131];
      u1147.currentgun:setequipped(true);
   end;
   local u1154 = v13;
   local t_loadknife_468 = v3151;
   local f_swapknife;
   f_swapknife = function(p520, p521, p522)
      --[[
         Name: swapknife
         Upvalues: 
            1 => u1134
            2 => u1154
            3 => u1132
            4 => t_loadknife_468
   
      --]]
      u1134 = true;
      local v3172 = u1154.currentgun;
      local v3173 = u1132;
      if (v3172 == v3173) then
         u1154.currentgun:setequipped(false);
      else
         u1132:destroy();
      end
      if (not p522) then
         wait(0.4);
      end
      u1132 = nil;
      if (not p522) then
         wait(0.1);
      end
      u1132 = t_loadknife_468(p520, p521);
      u1154.currentgun = u1132;
      u1154.currentgun:setequipped(true);
      if (not p522) then
         wait(0.4);
      end
      u1134 = false;
   end;
   local u1155 = v13;
   local u1156 = v3160;
   local t_loadgun_469 = v3152;
   local f_swapgun;
   f_swapgun = function(p523, p524, p525, p526, p527, p528, p529, p530)
      --[[
         Name: swapgun
         Upvalues: 
            1 => u1134
            2 => u1131
            3 => u1155
            4 => u1156
            5 => t_loadgun_469
            6 => u1135
   
      --]]
      u1134 = true;
      u1131 = p529;
      if (u1155.currentgun) then
         u1155.currentgun:setequipped(false);
      end
      if (not p530) then
         wait(0.4);
      end
      if (u1156[p529]) then
         u1156[p529]:destroy();
         u1156[p529] = nil;
      end
      if (not p530) then
         wait(0.4);
      end
      local v3174 = t_loadgun_469(p523, p524, p525, p526, p527, p528, p529);
      u1156[p529] = v3174;
      u1155.currentgun = v3174;
      u1135 = v3174;
      v3174:setequipped(true);
      if (not p530) then
         wait(0.4);
      end
      u1134 = false;
   end;
   local u1157 = v3160;
   local f_removeweapon;
   f_removeweapon = function(p531)
      --[[
         Name: removeweapon
         Upvalues: 
            1 => u1157
   
      --]]
      if (u1157[p531]) then
         u1157[p531]:remove();
         u1157[p531] = nil;
      end
   end;
   local v3175 = v33.mouse.onbuttondown;
   local u1158 = v13;
   v3175:connect(function(p532)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1158
            2 => u1134
   
      --]]
      if (not (u1158.currentgun and (not u1134))) then
         return;
      end
      if (not ((p532 == "left") and u1158.currentgun.shoot)) then
         if (p532 == "right") then
            if (u1158.currentgun.inspecting()) then
               u1158.currentgun:reloadcancel(true);
            end
            if (u1158.currentgun.setaim) then
               u1158.currentgun:setaim(true);
               return;
            end
            local t_type_470 = u1158.currentgun.type;
            if (t_type_470 == "KNIFE") then
               u1158.currentgun:shoot(false, "stab2");
            end
         end
         return;
      end
      if (u1158.currentgun.inspecting()) then
         u1158.currentgun:reloadcancel(true);
      end
      local t_type_471 = u1158.currentgun.type;
      if (t_type_471 == "KNIFE") then
         u1158.currentgun:shoot(false, "stab1");
         return;
      end
      u1158.currentgun:shoot(true);
   end);
   local v3176 = v33.mouse.onscroll;
   local u1159 = v5;
   local f_switch = f_switch;
   v3176:connect(function(...)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1159
            2 => f_switch
   
      --]]
      if (not u1159.grenadehold) then
         f_switch(...);
      end
   end);
   local v3177 = v33.mouse.onbuttonup;
   local u1160 = v13;
   v3177:connect(function(p533)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1160
   
      --]]
      if (not u1160.currentgun) then
         return;
      end
      if ((p533 == "left") and u1160.currentgun.shoot) then
         u1160.currentgun:shoot(false);
         return;
      end
      if ((p533 == "right") and u1160.currentgun.setaim) then
         u1160.currentgun:setaim(false);
      end
   end);
   local v3178 = v33.keyboard.onkeydown;
   local u1161 = v13;
   local u1162 = v5;
   local u1163 = v12;
   local u1164 = v3157;
   local u1165 = v33;
   local u1166 = v7;
   local t_FindFirstChild_472 = v3153;
   local t_PlayerGui_473 = v3159;
   local u1167 = v3155;
   local t_Debris_474 = v3154;
   local u1168 = v3;
   local u1169 = v3160;
   local u1170 = v18;
   local f_switch = f_switch;
   local u1171 = v40;
   local t_LocalPlayer_475 = v3158;
   local u1172 = v1;
   v3178:connect(function(p534)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1161
            2 => u1162
            3 => u1163
            4 => u1164
            5 => u1165
            6 => u1141
            7 => u1133
            8 => u1138
            9 => u1137
            10 => u1166
            11 => u1139
            12 => u1132
            13 => u1135
            14 => u1134
            15 => u1136
            16 => t_FindFirstChild_472
            17 => t_PlayerGui_473
            18 => u1167
            19 => t_Debris_474
            20 => u1168
            21 => u1131
            22 => u1169
            23 => u1170
            24 => f_switch
            25 => u1140
            26 => u1171
            27 => t_LocalPlayer_475
            28 => u1172
   
      --]]
      if (not (u1161.currentgun and u1162.alive)) then
         return;
      end
      if (((u1163.lock and (not (p534 == "h"))) and (not ((p534 == "q") or (p534 == "f")))) and (not (((p534 == "one") or (p534 == "two")) or (p534 == "three")))) then
         return;
      end
      if (u1164:IsStudio()) then
         u1165.mouse:lockcenter();
      end
      if (p534 == "space") then
         local v3179 = u1141;
         local v3180 = tick();
         if (v3179 < v3180) then
            if (u1162:jump(4)) then
               u1141 = tick() + 0.6666666666666666;
               return;
            end
            u1141 = tick() + 0.25;
            return;
         end
      else
         if (p534 == "c") then
            if (not (u1162.getslidecondition() and (not u1133))) then
               local v3181 = u1162;
               local t_movementmode_480 = u1162.movementmode;
               local v3182;
               if (t_movementmode_480 == "crouch") then
                  v3182 = "prone";
               else
                  v3182 = "crouch";
               end
               v3181:setmovementmode(v3182);
               return;
            end
            u1133 = true;
            u1162:setmovementmode("crouch", u1133);
            wait(0.2);
            u1138 = false;
            wait(0.9);
            u1133 = false;
            return;
         end
         if (p534 == "x") then
            if (u1162.sprinting() and (not u1133)) then
               u1133 = true;
               u1162:setmovementmode("prone", u1133);
               wait(0.8);
               u1138 = false;
               if (u1162.sprinting() and (not u1138)) then
                  u1162:setsprint(true);
               end
               wait(1.8);
               u1133 = false;
               return;
            end
            if (not u1133) then
               local v3183 = u1162;
               local t_movementmode_479 = u1162.movementmode;
               local v3184;
               if (t_movementmode_479 == "crouch") then
                  v3184 = "stand";
               else
                  v3184 = "crouch";
               end
               v3183:setmovementmode(v3184);
               return;
            end
         else
            if (p534 == "leftcontrol") then
               if (not (u1162.getslidecondition() and (not u1133))) then
                  u1162:setmovementmode("prone");
                  return;
               end
               u1133 = true;
               u1162:setmovementmode("crouch", u1133);
               wait(0.2);
               u1138 = false;
               wait(0.9);
               u1133 = false;
               return;
            end
            if (p534 == "z") then
               if (u1162.sprinting() and (not u1133)) then
                  u1133 = true;
                  u1162:setmovementmode("prone", u1133);
                  wait(0.8);
                  u1138 = false;
                  wait(1.8);
                  u1133 = false;
                  return;
               end
               if (not u1133) then
                  u1162:setmovementmode("stand");
                  return;
               end
            else
               if (p534 == "r") then
                  if (u1161.currentgun.reload and (not u1161.currentgun.data.loosefiring)) then
                     u1161.currentgun:reload();
                     return;
                  end
               else
                  if (p534 == "e") then
                     if (((not u1162.grenadehold) and u1161.currentgun.playanimation) and (not u1137)) then
                        u1137 = true;
                        if (u1166:spot()) then
                           u1161.currentgun:playanimation("spot");
                        end
                        wait(1);
                        u1137 = false;
                        return;
                     end
                  else
                     if (p534 == "f") then
                        if (u1139 or u1162.grenadehold) then
                           return;
                        end
                        local v3185 = u1161.currentgun;
                        local v3186 = u1132;
                        if (v3185 == v3186) then
                           u1161.currentgun:shoot();
                           return;
                        end
                        u1139 = true;
                        if (u1132) then
                           u1135 = u1161.currentgun;
                           u1161.currentgun = u1132;
                        end
                        u1161.currentgun:setequipped(true, "stab1");
                        u1134 = true;
                        wait(0.5);
                        if ((not u1165.keyboard.down.f) and u1135) then
                           u1161.currentgun = u1135;
                           if (u1135) then
                              u1135:setequipped(true);
                           end
                        end
                        u1134 = false;
                        wait(0.5);
                        u1139 = false;
                        return;
                     end
                     if (p534 == "g") then
                        if (not ((u1139 or u1134) or u1162.grenadehold)) then
                           local t_gammo_478 = u1161.gammo;
                           if (t_gammo_478 > 0) then
                              u1136 = u1162:loadgrenade("FRAG", u1161.currentgun);
                              u1136:setequipped(true);
                              wait(0.3);
                              u1134 = false;
                              u1136:pull();
                              return;
                           end
                        end
                     else
                        if (p534 == "h") then
                           if (u1161.currentgun.isaiming() and u1161.currentgun.isblackscope()) then
                              return;
                           end
                           if (not ((u1162.grenadehold or u1137) or u1161.currentgun.inspecting())) then
                              u1161.currentgun:playanimation("inspect");
                              return;
                           end
                        else
                           if (p534 == "leftshift") then
                              if (u1161.currentgun.isaiming() and u1161.currentgun.isblackscope()) then
                                 return;
                              end
                              if (not u1138) then
                                 if (u1165.sprinttoggle) then
                                    u1162:setsprint(not u1162.sprinting());
                                    return;
                                 end
                                 u1162:setsprint(true);
                                 return;
                              end
                           else
                              if (p534 == "w") then
                                 if (t_FindFirstChild_472(t_PlayerGui_473, "Doubletap") or u1162.sprinting()) then
                                    if (u1161.currentgun.isaiming() and u1161.currentgun.isblackscope()) then
                                       return;
                                    end
                                    if (not u1138) then
                                       u1162:setsprint(true);
                                       return;
                                    end
                                 else
                                    local v3187 = u1167("Model");
                                    v3187.Name = "Doubletap";
                                    v3187.Parent = t_PlayerGui_473;
                                    t_Debris_474:AddItem(v3187, 0.2);
                                    return;
                                 end
                              else
                                 if (p534 == "q") then
                                    if (u1161.currentgun.inspecting()) then
                                       u1161.currentgun:reloadcancel(true);
                                    end
                                    if (u1161.currentgun.setaim) then
                                       u1161.currentgun:setaim(not u1161.currentgun.isaiming());
                                       return;
                                    end
                                 else
                                    if (p534 == "m") then
                                       if (u1168) then
                                          if (u1165.mouse:visible()) then
                                             u1165.mouse:hide();
                                             return;
                                          end
                                          u1165.mouse:show();
                                          return;
                                       end
                                    else
                                       if (p534 == "t") then
                                          if (u1161.currentgun.toggleattachment) then
                                             u1161.currentgun:toggleattachment();
                                             return;
                                          end
                                       else
                                          if (p534 == "v") then
                                             if (u1134 or u1162.grenadehold) then
                                                return;
                                             end
                                             if (u1166:getuse()) then
                                                local u1173 = u1161.currentgun;
                                                delay(0.15, function()
                                                   --[[
                                                      Name: (empty)
                                                      Upvalues: 
                                                         1 => u1165
                                                         2 => u1162
                                                         3 => t_FindFirstChild_472
                                                         4 => u1173
                                                         5 => u1132
                                                         6 => u1131
                                                         7 => u1161
                                                         8 => u1169
                                                         9 => u1170
   
                                                   --]]
                                                   if (not u1165.keyboard.down.v) then
                                                      return;
                                                   end
                                                   local v3188 = workspace.Ignore.GunDrop:GetChildren();
                                                   local v3189 = v3188;
                                                   local v3190 = 8;
                                                   local v3191 = nil;
                                                   local v3192 = nil;
                                                   local v3193 = 1;
                                                   local v3194 = #v3188;
                                                   local v3195 = v3194;
                                                   local v3196 = v3193;
                                                   if (not (v3194 <= v3196)) then
                                                      while true do
                                                         local v3197 = v3189[v3193];
                                                         local v3198 = v3197;
                                                         local t_Name_476 = v3197.Name;
                                                         if (t_Name_476 == "Dropped") then
                                                            local v3199 = (v3198.Slot1.Position - u1162.rootpart.Position).magnitude;
                                                            local t_magnitude_477 = v3199;
                                                            if (v3199 < v3190) then
                                                               if (t_FindFirstChild_472(v3198, "Gun")) then
                                                                  v3190 = t_magnitude_477;
                                                                  v3191 = v3198;
                                                                  v3192 = nil;
                                                               else
                                                                  if (t_FindFirstChild_472(v3198, "Knife")) then
                                                                     v3190 = t_magnitude_477;
                                                                     v3192 = v3198;
                                                                     v3191 = nil;
                                                                  end
                                                               end
                                                            end
                                                         end
                                                         local v3200 = v3193 + 1;
                                                         v3193 = v3200;
                                                         local v3201 = v3195;
                                                         if (v3201 < v3200) then
                                                            break;
                                                         end
                                                      end
                                                   end
                                                   if (not v3191) then
                                                      if (v3192) then
                                                         u1170:send("swapweapon", v3192);
                                                         print("sent knife");
                                                      end
                                                      return;
                                                   end
                                                   local v3202 = u1173;
                                                   local v3203 = u1132;
                                                   if (v3202 == v3203) then
                                                      u1131 = 2;
                                                      u1161.currentgun = u1169[u1131];
                                                      u1173 = u1161.currentgun;
                                                      u1161.currentgun:setequipped(true);
                                                   end
                                                   u1170:send("swapweapon", v3191, u1131);
                                                end);
                                                return;
                                             end
                                             if (u1161.currentgun.nextfiremode) then
                                                u1161.currentgun:nextfiremode();
                                                return;
                                             end
                                          else
                                             if ((p534 == "one") or (p534 == "two")) then
                                                if (not u1162.grenadehold) then
                                                   f_switch(p534);
                                                   return;
                                                end
                                             else
                                                if (p534 == "three") then
                                                   local v3204 = u1161.currentgun;
                                                   local v3205 = u1132;
                                                   if ((v3204 == v3205) or u1162.grenadehold) then
                                                      return;
                                                   end
                                                   if (u1132) then
                                                      u1135 = u1161.currentgun;
                                                      u1161.currentgun = u1132;
                                                   end
                                                   u1161.currentgun:setequipped(true);
                                                   wait(0.5);
                                                   u1134 = false;
                                                   return;
                                                end
                                                if ((p534 == "f5") or (p534 == "f8")) then
                                                   if (u1140 or u1165.keyboard.down.leftshift) then
                                                      return;
                                                   end
                                                   u1140 = true;
                                                   u1162:despawn();
                                                   if (not (u1171.IsTest() or u1171.IsVIP())) then
                                                      local v3206 = game:GetService("ReplicatedStorage"):WaitForChild("Misc").RespawnGui.Title:Clone();
                                                      local v3207 = v3206;
                                                      v3206.Parent = t_LocalPlayer_475.PlayerGui:FindFirstChild("MainGui");
                                                      local v3208 = 5;
                                                      local v3209 = v3208;
                                                      if (not (v3209 <= 0)) then
                                                         while true do
                                                            if (not u1172) then
                                                               v3207.Count.Text = v3208;
                                                               wait(1);
                                                            end
                                                            local v3210 = v3208 + -1;
                                                            v3208 = v3210;
                                                            if (v3210 < 0) then
                                                               break;
                                                            end
                                                         end
                                                      end
                                                      v3207:Destroy();
                                                   end
                                                   u1140 = false;
                                                end
                                             end
                                          end
                                       end
                                    end
                                 end
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end);
   local v3211 = v33.keyboard.onkeyup;
   local u1174 = v13;
   local u1175 = v33;
   local u1176 = v5;
   v3211:connect(function(p535)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1174
            2 => u1175
            3 => u1176
   
      --]]
      if (not u1174.currentgun) then
         return;
      end
      if (((p535 == "leftshift") or ((p535 == "w") and (not u1175.keyboard.down.leftshift))) and (not u1175.sprinttoggle)) then
         u1176:setsprint(false);
      end
   end);
   v33.controller:map("a", "space");
   v33.controller:map("x", "r");
   v33.controller:map("r1", "g");
   v33.controller:map("up", "h");
   v33.controller:map("r3", "f");
   v33.controller:map("right", "v");
   v33.controller:map("down", "e");
   v33.controller:map("left", "t");
   local u1177 = nil;
   local v3212 = v33.controller.onbuttondown;
   local u1178 = v13;
   local u1179 = v12;
   local u1180 = v5;
   local u1181 = v7;
   local u1182 = v33;
   local t_FindFirstChild_481 = v3153;
   local u1183 = v3160;
   local u1184 = v18;
   v3212:connect(function(p536)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1178
            2 => u1179
            3 => u1180
            4 => u1133
            5 => u1138
            6 => u1137
            7 => u1181
            8 => u1134
            9 => u1177
            10 => u1182
            11 => t_FindFirstChild_481
            12 => u1132
            13 => u1131
            14 => u1183
            15 => u1184
            16 => u1140
   
      --]]
      if (not u1178.currentgun) then
         return;
      end
      if (u1179.lock) then
         return;
      end
      if (p536 ~= "b") then
         if (not ((p536 == "r2") and u1178.currentgun.shoot)) then
            if (p536 == "l2") then
               if (u1178.currentgun.inspecting()) then
                  u1178.currentgun:reloadcancel(true);
               end
               if (u1178.currentgun.setaim) then
                  u1178.currentgun:setaim(true);
                  return;
               end
               local t_type_484 = u1178.currentgun.type;
               if (t_type_484 == "KNIFE") then
                  u1178.currentgun:shoot(false, "stab2");
                  return;
               end
            else
               if (p536 == "l1") then
                  if (u1180.sprinting() and (not u1133)) then
                     u1133 = true;
                     u1180:setmovementmode("prone", u1133);
                     wait(0.8);
                     u1138 = false;
                     wait(1.8);
                     u1133 = false;
                     return;
                  end
                  if (((not u1180.grenadehold) and u1178.currentgun.playanimation) and (not u1137)) then
                     u1137 = true;
                     if (u1181:spot()) then
                        u1178.currentgun:playanimation("spot");
                     end
                     wait(1);
                     u1137 = false;
                     return;
                  end
               else
                  if (p536 == "y") then
                     if (u1134 or u1180.grenadehold) then
                        return;
                     end
                     u1177 = false;
                     if (u1181:getuse()) then
                        delay(0.2, function()
                           --[[
                              Name: (empty)
                              Upvalues: 
                                 1 => u1182
                                 2 => u1177
                                 3 => u1180
                                 4 => t_FindFirstChild_481
                                 5 => u1178
                                 6 => u1132
                                 7 => u1131
                                 8 => u1183
                                 9 => u1184
   
                           --]]
                           if (not u1182.controller.down.y) then
                              return;
                           end
                           u1177 = true;
                           local v3213 = workspace.Ignore.GunDrop:GetChildren();
                           local v3214 = v3213;
                           local v3215 = 8;
                           local v3216 = nil;
                           local v3217 = nil;
                           local v3218 = 1;
                           local v3219 = #v3213;
                           local v3220 = v3219;
                           local v3221 = v3218;
                           if (not (v3219 <= v3221)) then
                              while true do
                                 local v3222 = v3214[v3218];
                                 local v3223 = v3222;
                                 local t_Name_482 = v3222.Name;
                                 if (t_Name_482 == "Dropped") then
                                    local v3224 = (v3223.Slot1.Position - u1180.rootpart.Position).magnitude;
                                    local t_magnitude_483 = v3224;
                                    if (v3224 < v3215) then
                                       if (t_FindFirstChild_481(v3223, "Gun")) then
                                          v3215 = t_magnitude_483;
                                          v3216 = v3223;
                                          v3217 = nil;
                                       else
                                          if (t_FindFirstChild_481(v3223, "Knife")) then
                                             v3215 = t_magnitude_483;
                                             v3217 = v3223;
                                             v3216 = nil;
                                          end
                                       end
                                    end
                                 end
                                 local v3225 = v3218 + 1;
                                 v3218 = v3225;
                                 local v3226 = v3220;
                                 if (v3226 < v3225) then
                                    break;
                                 end
                              end
                           end
                           if (not v3216) then
                              if (v3217) then
                                 u1184:send("swapweapon", v3217);
                              end
                              return;
                           end
                           local v3227 = u1178.currentgun;
                           local v3228 = u1132;
                           if (v3227 == v3228) then
                              u1131 = 2;
                              u1178.currentgun = u1183[u1131];
                              u1178.currentgun:setequipped(true);
                           end
                           u1184:send("swapweapon", v3216, u1131);
                        end);
                        return;
                     end
                  else
                     if (p536 == "l3") then
                        if (u1178.currentgun.isaiming() and u1178.currentgun.isblackscope()) then
                           u1178.steadytoggle = not u1178.steadytoggle;
                           return;
                        end
                        if (not u1138) then
                           if (u1178.currentgun.isaiming() and u1178.currentgun.setaim) then
                              u1178.steadytoggle = false;
                              u1178.currentgun:setaim(false);
                           end
                           u1180:setsprint(not u1180.sprinting());
                           return;
                        end
                     else
                        if (p536 == "select") then
                           if (u1140) then
                              return;
                           end
                           u1140 = true;
                           local v3229 = 1;
                           local v3230 = v3229;
                           if (not (v3230 >= 20)) then
                              while true do
                                 wait(0.1);
                                 if (u1140) then
                                    local v3231 = v3229 + 1;
                                    v3229 = v3231;
                                    if (v3231 > 20) then
                                       break;
                                    end
                                 else
                                    break;
                                 end
                              end
                              return;
                           end
                           if (u1140) then
                              u1140 = false;
                              u1180:despawn();
                           end
                        end
                     end
                  end
               end
            end
            return;
         end
         if (u1178.currentgun.inspecting()) then
            u1178.currentgun:reloadcancel(true);
         end
         u1178.currentgun:shoot(true);
         return;
      end
      local t_movementmode_485 = u1180.movementmode;
      if (t_movementmode_485 == "crouch") then
         u1180:setmovementmode("prone");
         return;
      end
      if (not (u1180.sprinting() and (not u1133))) then
         u1180:setmovementmode("crouch");
         return;
      end
      u1133 = true;
      u1180:setmovementmode("crouch", u1133);
      wait(1);
      u1133 = false;
   end);
   local v3232 = v33.controller.onbuttonup;
   local u1185 = v13;
   local f_switch = f_switch;
   v3232:connect(function(p537)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1185
            2 => u1177
            3 => f_switch
            4 => u1140
   
      --]]
      if (not u1185.currentgun) then
         return;
      end
      if (p537 == "r2") then
         u1185.currentgun:shoot(false);
         return;
      end
      if (p537 == "y") then
         if (not u1177) then
            f_switch(1);
            return;
         end
      else
         if ((p537 == "l2") and u1185.currentgun.setaim) then
            u1185.steadytoggle = false;
            if (u1185.currentgun.isaiming()) then
               u1185.currentgun:setaim(false);
               return;
            end
         else
            if ((p537 == "select") and u1140) then
               u1140 = false;
            end
         end
      end
   end);
   local u1186 = v13;
   local u1187 = v33;
   local u1188 = v5;
   local f_controllerstep;
   f_controllerstep = function()
      --[[
         Name: controllerstep
         Upvalues: 
            1 => u1186
            2 => u1187
            3 => u1188
   
      --]]
      if (not u1186.currentgun) then
         return;
      end
      if (u1187.controller.down.b) then
         local v3233 = u1187.controller.down.b + 0.5;
         local v3234 = tick();
         if (v3233 < v3234) then
            local t_movementmode_486 = u1188.movementmode;
            if (t_movementmode_486 ~= "prone") then
               u1188:setmovementmode("prone");
            end
         end
      end
   end;
   v13.controllerstep = f_controllerstep;
   local v3235 = v5.ondied;
   local u1189 = v7;
   local u1190 = v13;
   local u1191 = v11;
   local t_FindFirstChild_487 = v3153;
   local t_LocalPlayer_488 = v3158;
   local u1192 = v5;
   v3235:connect(function(p538)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1141
            2 => u1189
            3 => u1190
            4 => u1191
            5 => t_FindFirstChild_487
            6 => t_LocalPlayer_488
            7 => u1192
   
      --]]
      u1141 = 0;
      u1189:setscope(false);
      if (u1190.currentgun) then
         u1190.currentgun:setequipped(false, "death");
         u1190.currentgun = nil;
      end
      if (not p538) then
         wait(5);
      end
      u1191:loadmenu(true);
      if (not t_FindFirstChild_487(t_LocalPlayer_488, "ForceR")) then
         u1192:setmovementmode("stand");
      end
   end);
   v18:add("spawn", f_loadmodules);
   v18:add("swapgun", f_swapgun);
   v18:add("removeweapon", f_removeweapon);
   v18:add("swapknife", f_swapknife);
   local u1193 = v3160;
   v18:add("addammo", function(p539, p540, p541)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1193
   
      --]]
      if (u1193[p539]) then
         u1193[p539]:addammo(p540, p541);
      end
   end);
   v11:loadmenu();
   v18:add("setuiscale", v38.setscale);
   local v3236 = Instance.new;
   local v3237 = Vector3.new;
   local v3238 = CFrame.new;
   local v3239 = game.FindFirstChild;
   local v3240 = workspace.Ignore.DeadBody;
   local v3241 = shared.require("bodysetup");
   local v3242 = shared.require("ragdolltable");
   local u1194 = v3236;
   local u1195 = v3237;
   local u1196 = v3238;
   local f_weldball;
   f_weldball = function(p542, p543)
      --[[
         Name: weldball
         Upvalues: 
            1 => u1194
            2 => u1195
            3 => u1196
   
      --]]
      local v3243 = false;
      local v3244 = u1194("Part");
      local v3245 = v3244;
      v3244:BreakJoints();
      v3244.Shape = "Ball";
      v3244.CastShadow = false;
      v3244.TopSurface = 0;
      v3244.BottomSurface = 0;
      v3244.formFactor = "Custom";
      v3244.Size = u1195(0.25, 0.25, 0.25);
      v3244.Transparency = 1;
      v3244.CollisionGroupId = 3;
      local v3246 = u1194("Weld");
      local v3247 = v3246;
      v3246.Part0 = p542;
      v3246.Part1 = v3244;
      local v3248;
      if (p543) then
         v3243 = true;
      else
         v3248 = u1196(0, -0.5, 0);
         if (not v3248) then
            v3243 = true;
         end
      end
      if (v3243) then
         v3248 = p543;
      end
      v3247.C0 = v3248;
      v3247.Parent = v3245;
      v3245.Parent = p542;
   end;
   local u1197 = v3236;
   local u1198 = v3237;
   local u1199 = v3242;
   local f_weldtorso;
   f_weldtorso = function(p544, p545)
      --[[
         Name: weldtorso
         Upvalues: 
            1 => u1197
            2 => u1198
            3 => u1199
   
      --]]
      local v3249 = u1197("Part");
      v3249.CastShadow = false;
      v3249.Size = u1198(0.1, 0.1, 0.1);
      v3249.Shape = "Ball";
      v3249.TopSurface = "Smooth";
      v3249.BottomSurface = "Smooth";
      v3249.Transparency = 1;
      v3249.CanCollide = false;
      v3249.CollisionGroupId = 3;
      v3249.Parent = p544;
      game.Debris:AddItem(v3249, 5);
      local v3250 = u1197("Weld");
      v3250.Part0 = p544;
      v3250.Part1 = v3249;
      v3250.C0 = u1199[p544.Name].c;
      v3250.Parent = v3249;
      local v3251 = u1197("Attachment");
      local v3252 = v3251;
      v3251.CFrame = u1199[p544.Name].a;
      v3251.Parent = p545;
      local v3253 = u1197("Attachment");
      local v3254 = v3253;
      v3253.CFrame = u1199[p544.Name].b;
      v3253.Parent = p544;
      if (u1199[p544.Name].d0) then
         v3252.Axis = u1199[p544.Name].d0;
         v3254.Axis = u1199[p544.Name].d1;
      end
      local v3255 = u1197("BallSocketConstraint");
      v3255.Attachment0 = v3252;
      v3255.Attachment1 = v3254;
      v3255.Restitution = 0.5;
      v3255.LimitsEnabled = true;
      v3255.UpperAngle = 70;
      v3255.Parent = p545;
   end;
   local u1200 = v3236;
   local u1201 = v3241;
   local u1202 = v3238;
   local t_FindFirstChild_489 = v3239;
   local u1203 = v3237;
   local f_weldtorso = f_weldtorso;
   local f_weldball = f_weldball;
   local t_DeadBody_490 = v3240;
   local f_ragdoll;
   f_ragdoll = function(p546, p547, p548)
      --[[
         Name: ragdoll
         Upvalues: 
            1 => u1200
            2 => u1201
            3 => u1202
            4 => t_FindFirstChild_489
            5 => u1203
            6 => f_weldtorso
            7 => f_weldball
            8 => t_DeadBody_490
   
      --]]
      local v3256 = u1200("Model");
      local u1204 = nil;
      local u1205 = nil;
      local u1206 = nil;
      local u1207 = nil;
      local u1208 = nil;
      local u1209 = nil;
      local v3257 = nil;
      if (p546) then
         local v3258 = p546:GetChildren();
         local v3259 = v3258;
         local v3260 = 1;
         local v3261 = #v3258;
         local v3262 = v3261;
         local v3263 = v3260;
         if (not (v3261 <= v3263)) then
            while true do
               local v3264 = false;
               local v3265 = v3259[v3260];
               local v3266 = v3265;
               if (v3265:IsA("Part")) then
                  local t_Transparency_494 = v3266.Transparency;
                  if ((t_Transparency_494 == 0) or u1201[v3266.Name]) then
                     local v3267 = u1200("Part");
                     local v3268 = v3267;
                     v3267.TopSurface = 0;
                     v3267.BottomSurface = 0;
                     v3267.Size = v3266.Size;
                     v3267.Color = v3266.Color;
                     v3267.CastShadow = false;
                     v3267.Anchored = false;
                     v3267.Name = v3266.Name;
                     v3267.CFrame = v3266.CFrame;
                     v3267.Velocity = v3266.Velocity;
                     v3267.CollisionGroupId = 3;
                     v3267.Parent = v3256;
                     local v3269 = v3266:GetChildren();
                     local v3270 = v3269;
                     local v3271 = 1;
                     local v3272 = #v3269;
                     local v3273 = v3272;
                     local v3274 = v3271;
                     if (not (v3272 <= v3274)) then
                        while true do
                           local v3275 = v3270[v3271];
                           local v3276 = v3275;
                           if (v3275:IsA("SpecialMesh") or v3275:IsA("Decal")) then
                              (v3276:Clone()).Parent = v3268;
                           end
                           local v3277 = v3271 + 1;
                           v3271 = v3277;
                           local v3278 = v3273;
                           if (v3278 < v3277) then
                              break;
                           end
                        end
                     end
                     local t_Name_495 = v3266.Name;
                     if (t_Name_495 == "Head") then
                        u1204 = v3268;
                     end
                     local t_Name_496 = v3266.Name;
                     if (t_Name_496 == "Torso") then
                        u1205 = v3268;
                     end
                     local t_Name_497 = v3266.Name;
                     if (t_Name_497 == "Left Arm") then
                        u1206 = v3268;
                     end
                     local t_Name_498 = v3266.Name;
                     if (t_Name_498 == "Right Arm") then
                        u1207 = v3268;
                     end
                     local t_Name_499 = v3266.Name;
                     if (t_Name_499 == "Left Leg") then
                        u1208 = v3268;
                     end
                     local t_Name_500 = v3266.Name;
                     if (t_Name_500 == "Right Leg") then
                        u1209 = v3268;
                     end
                     if (v3266 == p547) then
                        v3257 = v3268;
                     end
                  else
                     v3264 = true;
                  end
               else
                  v3264 = true;
               end
               if (v3264) then
                  if (v3266:IsA("Shirt") or v3266:IsA("Pants")) then
                     (v3266:Clone()).Parent = v3256;
                  end
               end
               local v3279 = v3260 + 1;
               v3260 = v3279;
               local v3280 = v3262;
               if (v3280 < v3279) then
                  break;
               end
            end
         end
         if (u1205) then
            if (u1204) then
               local v3281 = u1200("Weld");
               v3281.Part0 = u1205;
               v3281.Part1 = u1204;
               v3281.C0 = u1202(0, 1.5, 0);
               v3281.Parent = u1205;
               local v3282 = t_FindFirstChild_489(u1204, "Mesh");
               local v3283 = v3282;
               if (v3282) then
                  v3283.Scale = u1203(1.15, 1.15, 1.15);
                  v3283.Offset = u1203(0, 0.1, 0);
               end
            end
            if (u1207) then
               f_weldtorso(u1207, u1205);
            end
            if (u1206) then
               f_weldtorso(u1206, u1205);
            end
            if (u1209) then
               f_weldtorso(u1209, u1205);
            end
            if (u1208) then
               f_weldtorso(u1208, u1205);
            end
            f_weldball(u1205, u1202(0, 0.5, 0));
            v3256.Name = "Dead";
            v3256.Parent = t_DeadBody_490;
            if (v3257) then
               v3257:ApplyImpulseAtPosition(v3257.Velocity + p548, v3257.Position);
            end
            local g_delay_491 = delay;
            local u1210 = v3256;
            g_delay_491(5, function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u1210
   
               --]]
               local g_next_492 = next;
               local v3284, v3285 = u1210:GetChildren();
               local v3286 = v3284;
               local v3287 = v3285;
               while true do
                  local v3288, v3289 = g_next_492(v3286, v3287);
                  local v3290 = v3288;
                  local v3291 = v3289;
                  if (v3288) then
                     v3287 = v3290;
                     if (v3291:IsA("BasePart")) then
                        v3291.Anchored = true;
                     end
                  else
                     break;
                  end
               end
            end);
            local g_delay_493 = delay;
            local u1211 = v3256;
            g_delay_493(30, function()
               --[[
                  Name: (empty)
                  Upvalues: 
                     1 => u1207
                     2 => u1206
                     3 => u1209
                     4 => u1208
                     5 => u1205
                     6 => u1204
                     7 => u1211
   
               --]]
               local v3292 = 1;
               local v3293 = v3292;
               if (not (v3293 >= 20)) then
                  while true do
                     u1207.Transparency = v3292 / 20;
                     u1206.Transparency = v3292 / 20;
                     u1209.Transparency = v3292 / 20;
                     u1208.Transparency = v3292 / 20;
                     u1205.Transparency = v3292 / 20;
                     u1204.Transparency = v3292 / 20;
                     wait(0.01666666666666667);
                     local v3294 = v3292 + 1;
                     v3292 = v3294;
                     if (v3294 > 20) then
                        break;
                     end
                  end
               end
               u1211:Destroy();
            end);
         end
      end
   end;
   local u1212 = v35;
   local f_ragdoll = f_ragdoll;
   local u1213 = v10;
   v18:add("died", function(p549, p550, p551, p552)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1212
            2 => f_ragdoll
            3 => u1213
   
      --]]
      if (p550) then
         if (p551 and u1212.ragdolls) then
            f_ragdoll(p550, p551, p552);
         end
         p550.Parent = nil;
      end
      if (u1213.removecharacterhash) then
         u1213.removecharacterhash(p549);
      end
      if (u1213.getupdater) then
         local v3295 = u1213.getupdater(p549);
         local v3296 = v3295;
         if (v3295) then
            v3296.died();
         end
      end
   end);
   local v3297 = {
      "failed to load",
      "http request failed",
      "could not fetch",
      "download sound",
      "thumbnail"
   };
   local v3298 = game:GetService("LogService").MessageOut;
   local u1214 = v3297;
   local u1215 = v18;
   v3298:connect(function(p553, p554)
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1214
            2 => u1215
   
      --]]
      local v3299 = Enum.MessageType.MessageError;
      if (p554 == v3299) then
         local v3300 = 1;
         local v3301 = #u1214;
         local v3302 = v3301;
         local v3303 = v3300;
         if (not (v3301 <= v3303)) then
            while (not string.find(string.lower(p553), u1214[v3300])) do
               local v3304 = v3300 + 1;
               v3300 = v3304;
               local v3305 = v3302;
               if (v3305 < v3304) then
                  break;
               end
            end
            return;
         end
         u1215:send("debug", p553);
      end
   end);
   print("Framework finished loading, duration:", tick() - v2);
   game:GetService("RunService").Heartbeat:wait();
   v18:ready();
   shared.close();
   v20.Reset:connect(v41.clear);
   v15:addTask("input", v33.step);
   v15:addTask("char", v5.step);
   v15:addTask("camera", v30.step, {
      "input",
      "char"
   });
   v15:addTask("hud", v7.step, {
      "char",
      "camera",
      "weaponstep"
   });
   v15:addTask("notify", v8.step, {
      "char"
   });
   v15:addTask("leaderboard", v9.step);
   v15:addTask("weaponstep", v5.animstep, {
      "char",
      "particle",
      "camera"
   });
   v15:addTask("controllerstep", v13.controllerstep, {
      "char",
      "input"
   });
   v15:addTask("menu", v11.step, {
      "camera"
   });
   v15:addTask("particle", v34.step, {
      "camera"
   });
   v15:addTask("tween", v36.step, {
      "weaponstep"
   });
   v16:addTask("replication", v10.step);
   v16:addTask("daycycle", v35.daycyclestep);
   v16:addTask("blood", v35.bloodstep);
   v16:addTask("hudbeat", v7.beat);
   v16:addTask("radar", v7.radarstep);
   local v3306 = workspace:FindFirstChild("Map");
   local v3307 = workspace.Ignore.GunDrop;
   local t_GunDrop_501 = v3307;
   local u1216 = v7;
   local u1217 = v5;
   v16:addTask("dropcheck", function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => t_GunDrop_501
            2 => u1216
            3 => u1217
   
      --]]
      local v3308 = t_GunDrop_501:GetChildren();
      local v3309 = 8;
      u1216:gundrop(false);
      if (u1217.alive) then
         local v3310 = 1;
         local v3311 = #v3308;
         local v3312 = v3311;
         local v3313 = v3310;
         if (not (v3311 <= v3313)) then
            while true do
               local v3314 = v3308[v3310];
               local v3315 = v3314;
               local t_Name_502 = v3314.Name;
               if ((t_Name_502 == "Dropped") and v3314:FindFirstChild("Slot1")) then
                  local v3316 = (v3315.Slot1.Position - u1217.rootpart.Position).magnitude;
                  local t_magnitude_503 = v3316;
                  if (v3316 < v3309) then
                     v3309 = t_magnitude_503;
                     if (v3315:FindFirstChild("Gun")) then
                        u1216:gundrop(v3315, v3315.Gun.Value);
                     else
                        if (v3315:FindFirstChild("Knife")) then
                           u1216:gundrop(v3315, v3315.Knife.Value);
                        end
                     end
                  end
               end
               local v3317 = v3310 + 1;
               v3310 = v3317;
               local v3318 = v3312;
               if (v3318 < v3317) then
                  break;
               end
            end
         end
      end
   end);
   local u1218 = v5;
   local t_GunDrop_504 = v3307;
   local u1219 = v7;
   local u1220 = v3306;
   local u1221 = t_LocalPlayer_2;
   local u1222 = v18;
   v16:addTask("flagcheck", function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1218
            2 => t_GunDrop_504
            3 => u1219
            4 => u1220
            5 => u1221
            6 => u1222
   
      --]]
      if (u1218.alive) then
         local v3319 = t_GunDrop_504:GetChildren();
         u1219:capping(false);
         if (u1220) then
            local v3320 = u1220:FindFirstChild("AGMP");
            local v3321 = v3320;
            if (v3320) then
               local v3322 = v3321:GetChildren();
               local v3323 = v3322;
               local v3324 = 1;
               local v3325 = #v3322;
               local v3326 = v3325;
               local v3327 = v3324;
               if (not (v3325 <= v3327)) then
                  while true do
                     local v3328 = v3323[v3324];
                     local v3329 = v3328;
                     if (v3328:FindFirstChild("IsCapping") and v3328.IsCapping.Value) then
                        local v3330 = v3329.TeamColor.Value;
                        local t_TeamColor_508 = u1221.TeamColor;
                        if (((not (v3330 == t_TeamColor_508)) and u1218.rootpart) and ((v3329.Base.Position - u1218.rootpart.Position).magnitude < 15)) then
                           u1219:capping(v3329, v3329.CapPoint.Value);
                        end
                     end
                     local v3331 = v3324 + 1;
                     v3324 = v3331;
                     local v3332 = v3326;
                     if (v3332 < v3331) then
                        break;
                     end
                  end
               end
            end
            local v3333 = 1;
            local v3334 = #v3319;
            local v3335 = v3334;
            local v3336 = v3333;
            if (not (v3334 <= v3336)) then
               while true do
                  local v3337 = v3319[v3333];
                  local v3338 = v3337;
                  if (v3337:FindFirstChild("Base")) then
                     local t_Name_505 = v3338.Name;
                     if (t_Name_505 == "FlagDrop") then
                        if ((v3338.Base.Position - u1218.rootpart.Position).magnitude < 8) then
                           local v3339 = v3338.TeamColor.Value;
                           local t_TeamColor_507 = u1221.TeamColor;
                           if (((v3339 == t_TeamColor_507) and v3338:FindFirstChild("IsCapping")) and v3338.IsCapping.Value) then
                              u1219:capping(v3338, v3338.CapPoint.Value, "ctf");
                           end
                           u1222:send("captureflag", v3338.TeamColor.Value);
                        end
                     else
                        local t_Name_506 = v3338.Name;
                        if ((t_Name_506 == "DogTag") and ((v3338.Base.Position - u1218.rootpart.Position).magnitude < 6)) then
                           u1222:send("capturedogtag", v3338);
                        end
                     end
                  end
                  local v3340 = v3333 + 1;
                  v3333 = v3340;
                  local v3341 = v3335;
                  if (v3341 < v3340) then
                     break;
                  end
               end
               return;
            end
         end
      else
         u1219:capping(false);
      end
   end);
   local v3342 = Instance.new("BindableEvent");
   local v3343 = v3342.Event;
   local u1223 = v5;
   v3343:Connect(function()
      --[[
         Name: (empty)
         Upvalues: 
            1 => u1223
   
      --]]
      u1223:despawn();
   end);
   game:GetService("StarterGui"):SetCore("ResetButtonCallback", v3342);
   