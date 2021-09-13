-- Decompiled with the Synapse X Luau decompiler.

math.randomseed(tick());
local v1 = game:GetService("RunService"):IsStudio();
local l__Value__2 = game:GetService("ReplicatedFirst"):WaitForChild("GameData"):WaitForChild("Version", 3).Value;
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
while true do
	wait(1);
	if game:IsLoaded() and shared.require then
		break;
	end;
end;
local v4 = tick();
local v5 = shared.require("superusers")[l__LocalPlayer__3.UserId];
pcall(function()
	game:GetService("StarterGui"):SetCore("TopbarEnabled", false);
end);
local char = {};
local v7 = {};
local hud = {};
local v9 = {};
local replication = {};
local roundsystem = {
	raycastwhitelist = {}
};
shared.add("hud", hud);
shared.add("char", char);
shared.add("roundsystem", roundsystem);
shared.add("replication", replication);
local PublicSettings = shared.require("PublicSettings");
local RenderSteppedRunner = shared.require("RenderSteppedRunner");
local HeartbeatRunner = shared.require("HeartbeatRunner");
local network = shared.require("network");
local trash = shared.require("trash");
local vector = shared.require("vector");
local cframe = shared.require("cframe");
local spring = shared.require("spring");
local Event = shared.require("Event");
local ScreenCull = shared.require("ScreenCull");
local camera = shared.require("camera");
local sequencer = shared.require("sequencer");
local animation = shared.require("animation");
local input = shared.require("input");
local particle = shared.require("particle");
local effects = shared.require("effects");
local tween = shared.require("tween");
local uiscaler = shared.require("uiscaler");
local InstanceType = shared.require("InstanceType");
local sound = shared.require("sound");
local ModifyData = shared.require("ModifyData");
local u1 = shared.require("GunDataGetter");
u1 = print;
u1("Loading data module");
u1 = {};
local u2 = {};
network:add("loadplayerdata", function(p1)
	u1 = p1;
	u2.loaded = true;
end);
network:add("updateplayerdata", function(p2, ...)
	local v33 = nil;
	local v34 = { ... };
	v33 = u1;
	for v35 = 1, #v34 - 1 do
		if not v33[v34[v35]] then
			v33[v34[v35]] = {};
		end;
		v33 = v33[v34[v35]];
	end;
	local v36[v34[#v34]] = p2;
end);
local u3 = {};
network:add("updateinventorydata", function(p3)
	if not u1.settings then
		u1.settings = {};
	end;
	u1.settings.inventorydata = p3;
	if u3.updateinventorydata then
		u3.updateinventorydata(u1.settings.inventorydata);
	end;
end);
network:add("updatepitydata", function(p4)
	u1.settings.pitydata = p4;
end);
network:add("updateunlocksdata", function(p5)
	u1.unlocks = p5;
end);
network:add("updateexperience", function(p6)
	u1.stats.experience = p6;
end);
network:add("updatetotalkills", function(p7)
	u1.stats.totalkills = p7;
end);
network:add("updatetotaldeaths", function(p8)
	u1.stats.totaldeaths = p8;
end);
network:add("updategunkills", function(p9, p10)
	local v37 = u1.unlocks[p9];
	if not v37 then
		v37 = {};
		u1.unlocks[p9] = v37;
	end;
	v37.kills = p10;
end);
function u2.getdata()
	return u1;
end;
local u4 = function()
	local v38 = u2.getdata().settings.attloadoutdata;
	if not v38 then
		v38 = {};
		u1.settings.attloadoutdata = v38;
	end;
	return v38;
end;
local u5 = function(p11)
	local v39 = u4();
	local v40 = v39[p11];
	if not v40 then
		v40 = {};
		v39[p11] = v40;
	end;
	return v40;
end;
local u6 = function(p12, p13)
	if not p13 then
		return;
	end;
	local v41 = u5(p12);
	local v42 = v41[p13];
	if not v42 then
		v42 = {};
		v41[p13] = v42;
	end;
	return v42;
end;
network:add("updateattachkills", function(p14, p15, p16)
	if p15 then
		u6(p14, p15).kills = p16;
	end;
end);
u2.getattloadoutdata = u4;
u2.getgunattdata = u5;
u2.getattachdata = u6;
u4 = function(p17)
	network:send("updatesettings", p17);
end;
u2.updatesettings = u4;
u6 = "loadplayerdata";
u5 = network;
u4 = network.send;
u4(u5, u6);
print("Loading chat module");
local l__WaitForChild__43 = game.WaitForChild;
local l__Dot__44 = Vector3.new().Dot;
local l__IsA__45 = game.IsA;
local l__LocalPlayer__46 = game:GetService("Players").LocalPlayer;
local v47 = l__WaitForChild__43(l__LocalPlayer__46.PlayerGui, "ChatGame");
local v48 = l__WaitForChild__43(v47, "TextBox");
local v49 = l__WaitForChild__43(v47, "Warn");
local v50 = InstanceType.IsVIP();
local u7 = l__WaitForChild__43(v47, "Version");
local u8 = InstanceType.GetString();
function v7.updateversionstr(p18)
	u7.Text = string.format("<b>Version: %s-%s#%s</b>", l__Value__2, string.lower(u8), p18 and "N/A");
end;
local u9 = uiscaler.getscale;
local u10 = l__WaitForChild__43(game.ReplicatedStorage.Misc, "MsgerMain");
local u11 = l__WaitForChild__43;
local u12 = l__WaitForChild__43(v47, "GlobalChat");
local u13 = UDim2.new;
network:add("console", function(p19)
	local v51 = u10:Clone();
	local v52 = u11(v51, "Tag");
	v51.Text = "[Console]: ";
	v51.TextColor3 = Color3.new(0.4, 0.4, 0.4);
	v51.Msg.Text = p19;
	v51.Parent = u12;
	v51.Msg.Position = u13(0, v51.TextBounds.x / u9(), 0, 0);
end);
network:add("announce", function(p20)
	local v53 = u10:Clone();
	local v54 = u11(v53, "Tag");
	v53.Text = "[ANNOUNCEMENT]: ";
	v53.TextColor3 = Color3.new(0.9803921568627451, 0.6509803921568628, 0.10196078431372549);
	v53.Msg.Text = p20;
	v53.Parent = u12;
	v53.Msg.Position = u13(0, v53.TextBounds.x / u9(), 0, 0);
end);
network:add("chatted", function(p21, p22, p23, p24, p25)
	local v55 = u9();
	local v56 = u10:Clone();
	local v57 = u11(v56, "Tag");
	v56.Parent = u12;
	v57.Text = p23 and p23 .. " " or "";
	if p23 then
		if string.sub(p23, 0, 1) == "$" then
			v56.Position = u13(0.01, 50, 1, 20);
			v57.Staff.Visible = true;
			v57.Staff.Image = "rbxassetid://" .. string.sub(p23, 2);
			v57.Text = "    ";
		else
			local v58 = v57.TextBounds.x / v55 + 5;
			v56.Position = u13(0.01, v58, 1, 20);
			v57.Position = u13(0, -v58 + 5, 0, 0);
			if p24 then
				v57.TextColor3 = p24;
			end;
		end;
	end;
	v56.Text = p21.Name .. " : ";
	v56.TextColor = p21.TeamColor;
	v56.Msg.Text = p22;
	if p25 then
		v56.Msg.TextColor3 = Color3.new(1, 0, 0);
	end;
	v56.Msg.Position = u13(0, v56.TextBounds.x / v55, 0, 0);
end);
network:add("printstring", function(...)
	local v59 = nil;
	local v60 = { ... };
	v59 = "";
	for v61 = 1, #v59 do
		v59 = v59 .. "\t" .. v60[v61];
	end;
	local v62 = 0;
	local v63 = "";
	for v64 in string.gmatch(local v65 .. "\n", "(^[\n]*)\n") do
		v62 = v62 + 1;
		v63 = v63 .. "\n" .. v64;
		if v62 == 64 then
			print(v63);
			v62 = 0;
			v63 = "";
		end;
	end;
end);
local u14 = v48;
local u15 = string.sub;
local u16 = string.len;
local u17 = 0;
local u18 = v49;
local u19 = 0;
local u20 = l__LocalPlayer__46;
function v7.hidechat(p26, p27)
	u12.Visible = not p27;
	u14.Visible = not p27;
end;
function v7.inmenu(p28)
	u12.Position = u13(0, 20, 1, -100);
	u14.Position = u13(0, 10, 1, -20);
end;
function v7.ingame(p29)
	u12.Position = u13(0, 150, 1, -50);
	u14.Position = u13(0, 10, 1, -20);
end;
local u21 = game.FindFirstChild;
u12.ChildAdded:connect(function(p30)
	task.wait();
	local v66 = u9();
	local v67 = u12:GetChildren();
	for v68 = 1, #v67 do
		local v69 = v67[v68];
		local v70 = u11(v69, "Tag");
		local v71 = 20;
		if v70.Text ~= "" then
			v71 = 20 + v70.TextBounds.x / v66;
			v69.Position = u13(0, v71, 1, v69.Position.Y.Offset);
		end;
		if v69.Parent then
			v69:TweenPosition(u13(0, v71, 1, (v68 - #v67) * 20), "Out", "Sine", 0.2, true);
		end;
		if #v67 > 8 and v68 <= #v67 - 8 and v69.Name ~= "Deleted" then
			v69.Name = "Deleted";
			u11(v69, "Msg");
			u11(v69, "Tag");
			for v72 = 1, 5 do
				if u21(v69, "Msg") and u21(v69, "Tag") then
					v69.TextTransparency = v72 * 2 / 10;
					v69.TextStrokeTransparency = v72 * 2 / 10 + 0.1;
					v69.Msg.TextTransparency = v72 * 2 / 10;
					v69.Msg.TextStrokeTransparency = v72 * 2 / 10 + 0.1;
					v69.Tag.TextTransparency = v72 * 2 / 10;
					v69.Tag.TextStrokeTransparency = v72 * 2 / 10 + 0.1;
					task.wait(0.03333333333333333);
				end;
				if v69 and v69.Parent then
					v69:Destroy();
				end;
			end;
		end;
	end;
end);
u14.Focused:connect(function()
	u14.Active = true;
end);
local function u22()
	local v73 = u14.Text;
	u14.Text = "Press '/' or click here to chat";
	u14.ClearTextOnFocus = true;
	u14.Active = false;
	if u15(v73, 1, 1) == "/" then
		network:send("modcmd", v73);
		u14.Text = "Press '/' or click here to chat";
		u14.ClearTextOnFocus = true;
		return;
	end;
	local v74 = nil;
	if u15(v73, 1, 1) == "%" then
		v74 = true;
		v73 = u15(v73, 2, u16(v73));
	end;
	if not (u17 > 5) then
		if u16(v73) > 256 then
			v73 = u15(v73, 1, 256);
		end;
		u17 = u17 + 1;
		network:send("chatted", v73, v74);
		task.delay(10, function()
			u17 = u17 - 1;
		end);
		return;
	end;
	u18.Visible = true;
	u17 = u17 + 1;
	u19 = u19 + 1;
	u18.Text = "You have been blocked temporarily for spamming.   WARNING : " .. u19 .. " out of 3";
	if u19 > 3 then
		u20:Kick("Kicked for repeated spamming");
	end;
	task.delay(5, function()
		u17 = u17 - 5;
		u18.Visible = false;
	end);
end;
u14.FocusLost:connect(function(p31)
	u14.Active = false;
	if p31 and u14.Text ~= "" then
		u22();
	end;
end);
game:GetService("UserInputService").InputBegan:connect(function(p32)
	if u18.Visible then
		return;
	end;
	local l__KeyCode__75 = p32.KeyCode;
	if not u14.Active then
		if l__KeyCode__75 ~= Enum.KeyCode.Slash then
			if l__KeyCode__75 == Enum.KeyCode[hud.voteyes] then
				hud:vote("yes");
				return;
			elseif l__KeyCode__75 == Enum.KeyCode[hud.votedismiss] then
				hud:vote("dismiss");
				return;
			else
				if l__KeyCode__75 == Enum.KeyCode[hud.voteno] then
					hud:vote("no");
				end;
				return;
			end;
		end;
	else
		return;
	end;
	task.wait(0.03333333333333333);
	u14:CaptureFocus();
	u14.ClearTextOnFocus = false;
end);
v7.updateversionstr();
u9 = print;
u11 = "Loading hud module";
u9(u11);
u9 = uiscaler.getscale;
u11 = UDim2.new;
u21 = CFrame.new;
u13 = Vector3.new;
local l__Dot__76 = Vector3.new().Dot;
local l__IsA__77 = game.IsA;
local l__Debris__78 = game.Debris;
u15 = game;
u16 = u15;
u15 = u15.GetService;
u15 = u15(u16, "Players");
local l__LocalPlayer__79 = u15.LocalPlayer;
u16 = game.ReplicatedStorage.Character;
u15 = u16.PlayerTag;
u16 = l__LocalPlayer__79.PlayerGui;
local l__ReplicatedStorage__80 = game.ReplicatedStorage;
local l__Misc__81 = l__ReplicatedStorage__80.Misc;
u8 = l__Misc__81.Spot;
u20 = l__Misc__81.Feed;
u10 = u16;
local v82 = u16.WaitForChild(u10, "MainGui");
u14 = "GameGui";
u10 = v82.WaitForChild;
u10 = u10(v82, u14);
u18 = "CrossHud";
u14 = u10;
local v83 = u10.WaitForChild(u14, u18);
u7 = "Sprint";
u18 = v83;
u14 = v83.WaitForChild;
u14 = u14(u18, u7);
u18 = {};
u12 = v83;
u7 = v83.WaitForChild;
u7 = u7(u12, "HR");
u12 = v83.WaitForChild;
u12 = u12(v83, "HL");
u18[1] = u7;
u18[2] = u12;
u18[3] = v83:WaitForChild("VD");
u18[4] = v83:WaitForChild("VU");
u12 = u10;
u7 = u10.WaitForChild;
u7 = u7(u12, "AmmoHud");
u12 = v82.WaitForChild;
u12 = u12(v82, "ScopeFrame");
local l__Hitmarker__84 = u10:WaitForChild("Hitmarker");
local l__NameTag__85 = u10:WaitForChild("NameTag");
local l__Capping__86 = u10:WaitForChild("Capping");
local l__BloodScreen__87 = u10:WaitForChild("BloodScreen");
local l__Radar__88 = u10:WaitForChild("Radar");
local l__Killfeed__89 = u10:WaitForChild("Killfeed");
local l__Steady__90 = u10:WaitForChild("Steady");
local l__Use__91 = u10:WaitForChild("Use");
local l__Round__92 = u10:WaitForChild("Round");
local l__Spotted__93 = u10:WaitForChild("Spotted");
local l__GlobalChat__94 = u16.ChatGame:WaitForChild("GlobalChat");
local l__Bar__95 = l__Steady__90:WaitForChild("Full"):WaitForChild("Bar");
local l__Folder__96 = l__Radar__88:WaitForChild("Folder");
local v97 = -l__Radar__88:WaitForChild("Me").Size.X.Offset / 2;
local l__Frame__98 = u7:WaitForChild("Frame");
local l__Ammo__99 = l__Frame__98:WaitForChild("Ammo");
local l__GAmmo__100 = l__Frame__98:WaitForChild("GAmmo");
local l__Mag__101 = l__Frame__98:WaitForChild("Mag");
local l__Health__102 = l__Frame__98:WaitForChild("Health");
local l__FMode__103 = l__Frame__98:WaitForChild("FMode");
local l__healthbar_back__104 = l__Frame__98:WaitForChild("healthbar_back");
local l__healthbar_fill__105 = l__healthbar_back__104:WaitForChild("healthbar_fill");
local v106 = { Color3.new(0.14901960784313725, 0.3137254901960784, 0.2784313725490196), Color3.new(0.17647058823529413, 0.5019607843137255, 0.43137254901960786), Color3.new(0.8745098039215686, 0.12156862745098039, 0.12156862745098039), Color3.new(0.5333333333333333, 0.06666666666666667, 0.06666666666666667) };
local l__Percent__107 = l__Capping__86:WaitForChild("Percent");
hud.crossscale = spring.new(0);
hud.crossscale.s = 10;
hud.crossscale.d = 0.8;
hud.crossscale.t = 1;
hud.crossspring = spring.new(0);
hud.crossspring.s = 12;
hud.crossspring.d = 0.65;
hud.hitspring = spring.new(1);
hud.hitspring.s = 5;
hud.hitspring.d = 0.7;
local l__Votekick__108 = u16.ChatGame:WaitForChild("Votekick");
local l__Yes__109 = l__Votekick__108:WaitForChild("Yes");
local l__No__110 = l__Votekick__108:WaitForChild("No");
local l__Dismiss__111 = l__Votekick__108:WaitForChild("Dismiss");
hud.voteyes = "Y";
hud.voteno = "N";
hud.votedismiss = "J";
l__Yes__109.Text = "Yes [" .. string.upper(hud.voteyes) .. "]";
l__No__110.Text = "No [" .. string.upper(hud.voteno) .. "]";
l__Dismiss__111.Text = "Dismiss [" .. string.upper(hud.votedismiss) .. "]";
local u23 = nil;
local u24 = l__Votekick__108;
local u25 = l__Votekick__108:WaitForChild("Timer");
local u26 = 0;
local u27 = l__Votekick__108:WaitForChild("Votes");
local u28 = 0;
local u29 = 0;
function hud.votestep()
	if not hud.disablevotekick and u23 then
		u24.Visible = true;
		u25.Text = "Time left: 0:" .. string.format("%.2d", (u26 - tick()) % 60);
		u27.Text = "Votes: " .. u28 .. " out of " .. u29 .. " required";
		if not (u26 <= tick()) and not (u29 <= u28) then
			return;
		end;
	else
		u24.Visible = false;
		return;
	end;
	u23 = false;
	u24.Visible = false;
end;
local u30 = nil;
local u31 = l__Yes__109;
local u32 = l__No__110;
local u33 = l__Dismiss__111;
local u34 = l__Votekick__108:WaitForChild("Choice");
function hud.vote(p33, p34)
	if u23 and not u30 then
		u31.Visible = false;
		u32.Visible = false;
		u33.Visible = false;
		u34.Visible = true;
		u30 = true;
		if p34 == "yes" then
			u34.Text = "Voted Yes";
			u34.TextColor3 = u31.TextColor3;
		elseif p34 == "dismiss" then
			u34.Text = "Vote Dismissed";
			u34.TextColor3 = u33.TextColor3;
			u23 = false;
			u24.Visible = false;
		else
			u34.Text = "Voted No";
			u34.TextColor3 = u32.TextColor3;
		end;
		network:send("votefromUI", p34);
	end;
end;
local u35 = l__Votekick__108:WaitForChild("Title");
network:add("startvotekick", function(p35, p36, p37)
	if not hud.disablevotekick then
		u35.Text = "Votekick " .. p35 .. " out of the server?";
		u24.Visible = true;
		u31.Visible = true;
		u32.Visible = true;
		u33.Visible = true;
		u34.Visible = false;
		u29 = p37;
		u28 = 0;
		u26 = tick() + p36;
		u23 = true;
		u30 = false;
		hud.votestep();
	end;
end);
network:add("updatenumvotes", function(p38)
	u28 = p38;
end);
local u36 = {};
u24 = function(p39)
	local v112 = u36[p39];
	if not v112 then
		v112 = {
			health0 = 0, 
			healtick0 = 0, 
			alive = false, 
			healrate = 0.25, 
			maxhealth = 100, 
			healwait = 8
		};
		u36[p39] = v112;
	end;
	return v112;
end;
u35 = function(p40, p41)
	local v113 = u24(p40);
	v113.alive = p41.alive;
	v113.health0 = p41.health0;
	v113.healtick0 = p41.healtick0;
end;
hud.updatehealth = u35;
u27 = "updateothershealth";
u31 = function(p42, p43, p44, p45)
	local v114 = u24(p42);
	v114.health0 = p43;
	v114.healtick0 = p44;
	v114.alive = p45;
	if u3.updatelist then
		u3.updatelist(p42, "Toggle");
	end;
end;
u25 = network;
u35 = network.add;
u35(u25, u27, u31);
u27 = "killfeed";
local u37 = {
	ammohud = {
		gui = u7, 
		enabled = true
	}, 
	radar = {
		gui = l__Radar__88, 
		enabled = true
	}, 
	killfeed = {
		gui = l__Killfeed__89, 
		enabled = true
	}, 
	crossframe = {
		gui = v83, 
		enabled = true
	}, 
	round = {
		gui = l__Round__92, 
		enabled = true
	}
};
local u38 = l__Killfeed__89;
local u39 = l__Misc__81.Headshot;
u31 = function(p46, p47, p48, p49, p50)
	if u37.killfeed.enabled then
		local v115 = uiscaler.getscale();
		local v116 = u20:Clone();
		v116.Parent = u38;
		v116.Text = p46.Name;
		v116.TextColor = p46.TeamColor;
		v116.GunImg.Text = p49;
		v116.Victim.Text = p47.Name;
		v116.Victim.TextColor = p47.TeamColor;
		v116.GunImg.Dist.Text = "Dist: " .. p48 .. " studs";
		v116.GunImg.Size = UDim2.new(0, v116.GunImg.TextBounds.x / v115, 0, 30);
		v116.GunImg.Position = UDim2.new(0, 15 + v116.TextBounds.x / v115, 0, -5);
		v116.Victim.Position = UDim2.new(0, 30 + v116.TextBounds.x / v115 + v116.GunImg.TextBounds.x / v115, 0, 0);
		if p50 then
			local v117 = u39:Clone();
			v117.Parent = v116.Victim;
			v117.Position = u11(0, 10 + v116.Victim.TextBounds.x / v115, 0, -5);
		end;
		task.spawn(function()
			v116.Visible = true;
			task.wait(20);
			for v118 = 1, 10 do
				if v116.Parent then
					v116.TextTransparency = v118 / 10;
					v116.TextStrokeTransparency = v118 / 10 + 0.5;
					v116.GunImg.TextStrokeTransparency = v118 / 10 + 0.5;
					v116.GunImg.TextTransparency = v118 / 10;
					v116.Victim.TextStrokeTransparency = v118 / 10 + 0.5;
					v116.Victim.TextTransparency = v118 / 10;
					task.wait(0.03333333333333333);
				end;
			end;
			if v116 and v116.Parent then
				v116:Destroy();
			end;
		end);
		local v119 = u38:GetChildren();
		for v120 = 1, #v119 do
			v119[v120]:TweenPosition(u11(0.01, 5, 1, (v120 - #v119) * 25 - 25), "Out", "Sine", 0.2, true);
			if #v119 > 5 and #v119 - v120 >= 5 then
				task.spawn(function()
					local v121 = v119[1];
					if v121.Name ~= "Deleted" then
						for v122 = 1, 10 do
							if v121:FindFirstChild("Victim") then
								v121.TextTransparency = v122 / 10;
								v121.TextStrokeTransparency = v122 / 10 + 0.5;
								v121.Victim.TextTransparency = v122 / 10;
								v121.Victim.TextStrokeTransparency = v122 / 10 + 0.5;
								v121.Name = "Deleted";
								v121.GunImg.TextTransparency = v122 / 10;
								v121.GunImg.TextStrokeTransparency = v122 / 10 + 0.5;
								task.wait(0.03333333333333333);
							end;
						end;
						v121:Destroy();
					end;
				end);
			end;
		end;
	end;
end;
u25 = network;
u35 = network.add;
u35(u25, u27, u31);
u25 = math.pi;
u35 = u25 / 180;
u25 = CFrame.Angles;
u31 = l__ReplicatedStorage__80.ServerSettings;
u27 = u31.GameMode;
u34 = l__ReplicatedStorage__80.GamemodeProps;
u33 = u34.FlagDrop;
u32 = u33.Base;
u31 = u32.PointLight;
u33 = l__ReplicatedStorage__80.GamemodeProps;
u32 = u33.FlagCarry;
u34 = l__ReplicatedStorage__80.GamemodeProps;
u33 = u34.FlagDrop;
u34 = BrickColor.new;
u34 = u34("Bright blue");
local v123 = BrickColor.new("Bright orange");
local u40 = {
	caplight = nil, 
	[u34.Name] = {
		revealtime = 0, 
		droptime = 0, 
		carrier = nil, 
		carrymodel = nil, 
		dropmodel = nil, 
		dropped = false, 
		basecf = u21()
	}, 
	[v123.Name] = {
		revealtime = 0, 
		droptime = 0, 
		carrier = nil, 
		carrymodel = nil, 
		dropmodel = nil, 
		dropped = false, 
		basecf = u21()
	}
};
local u41 = l__LocalPlayer__79;
local u42 = { u34, v123 };
local u43 = function(p51, p52)
	local v124 = u40[p51.Name];
	v124.revealtime = 0;
	v124.carrier = nil;
	if p52 == u41 and u40.caplight and u40.caplight.Parent then
		u40.caplight:Destroy();
		u40.caplight = nil;
		return;
	end;
	if v124.carrymodel and v124.carrymodel.Parent then
		v124.carrymodel:Destroy();
		v124.carrymodel = nil;
	end;
end;
local u44 = v123;
local u45 = Instance.new;
function hud.nearenemyflag(p53, p54)
	local v125 = p54.TeamColor == u34 and u44 or u34;
	if u40[v125.Name] and u40[v125.Name].basecf then
		local v126 = hud:getplayerpos(p54);
		if v126 and (u40[v125.Name].basecf.p - v126).Magnitude < 100 then
			return true;
		end;
	end;
	return false;
end;
local u46 = u10:WaitForChild("Captured");
local u47 = u10:WaitForChild("Revealed");
local function u48(p55)
	if not p55 or not p55.Parent or not replication.getbodyparts then
		return;
	end;
	local v127 = p55.TeamColor == u34 and u44 or u34;
	local v128 = replication.getbodyparts(p55);
	if v128 and v128.torso then
		local v129 = u32:Clone();
		v129.Tag.BrickColor = v127;
		v129.Tag.BillboardGui.Display.BackgroundColor3 = v127.Color;
		v129.Tag.BillboardGui.AlwaysOnTop = false;
		v129.Base.PointLight.Color = v127.Color;
		local l__next__130 = next;
		local v131, v132 = v129:GetChildren();
		while true do
			local v133, v134 = l__next__130(v131, v132);
			if not v133 then
				break;
			end;
			if v134 ~= v129.Base then
				local v135 = u45("Weld");
				v135.Part0 = v129.Base;
				v135.Part1 = v134;
				v135.C0 = v129.Base.CFrame:inverse() * v134.CFrame;
				v135.Parent = v129.Base;
			end;
			if v134:IsA("BasePart") then
				v134.Massless = true;
				v134.CastShadow = false;
				v134.Anchored = false;
				v134.CanCollide = false;
			end;		
		end;
		local v136 = u45("Weld");
		v136.Part0 = v128.torso;
		v136.Part1 = v129.Base;
		v136.Parent = v129.Base;
		v129.Parent = workspace.Ignore.Misc;
		u40[v127.Name].carrymodel = v129;
	end;
end;
function hud.gamemodestep()
	u46.Visible = false;
	u47.Visible = false;
	if u27.Value == "Capture the Flag" then
		local v137 = u41.TeamColor == u34 and u44 or u34;
		if u40[v137.Name].carrier == u41 and u40[v137.Name].revealtime then
			u46.Visible = true;
			u46.Text = "Capturing Enemy Flag!";
			u47.Visible = true;
			local l__revealtime__138 = u40[v137.Name].revealtime;
			if tick() < l__revealtime__138 then
				u47.Text = "Position revealed in " .. math.ceil(l__revealtime__138 - tick()) .. " seconds";
			else
				u47.Text = "Flag position revealed to all enemies!";
			end;
		end;
		for v139, v140 in next, u42 do
			local v141 = u40[v140.Name];
			if v141.carrier and v141.carrier ~= u41 then
				if not v141.carrier.Parent then
					u43(v140, nil);
				end;
				if not v141.carrymodel then
					u48(v141.carrier);
				end;
				if v141.carrymodel and v141.carrymodel.Parent and v141.revealtime then
					local l__BillboardGui__142 = v141.carrymodel.Tag.BillboardGui;
					if u41.TeamColor == v141.carrier.TeamColor then
						local v143 = "Capturing!";
					else
						v143 = "Stolen!";
					end;
					local v144 = true;
					if u41.TeamColor ~= v141.carrier.TeamColor then
						v144 = v141.revealtime < tick();
					end;
					l__BillboardGui__142.AlwaysOnTop = v144;
					l__BillboardGui__142.Distance.Text = v143;
				end;
			end;
		end;
	end;
end;
local u49 = 0;
function hud.gamemoderenderstep()
	u49 = u49 + 1;
	if u27.Value == "Capture the Flag" then
		local l__next__145 = next;
		local v146, v147 = workspace.Ignore.GunDrop:GetChildren();
		while true do
			local v148, v149 = l__next__145(v146, v147);
			if not v148 then
				break;
			end;
			v147 = v148;
			if v149.Name == "FlagDrop" then
				v149:SetPrimaryPartCFrame(v149.Location.Value * u21(0, 0.2 * math.sin(u49 * 5 * u35), 0) * u25(0, u49 * 4 * u35, 0));
				if u40[v149.TeamColor.Value.Name].dropped then
					local l__BillboardGui__150 = v149.Base:FindFirstChild("BillboardGui");
					local l__droptime__151 = u40[v149.TeamColor.Value.Name].droptime;
					if l__BillboardGui__150 and l__droptime__151 and tick() < l__droptime__151 + 60 then
						if u41.TeamColor ~= v149.TeamColor.Value then
							local v152 = "Pick up in: ";
						else
							v152 = "Returning in:";
						end;
						l__BillboardGui__150.Status.Text = v152 .. math.floor(l__droptime__151 + 60 - tick());
					end;
				end;
			end;		
		end;
	end;
end;
hud.attachflag = u48;
network:add("stealflag", function(p56, p57)
	local v153 = p56.TeamColor == u34 and u44 or u34;
	u40[v153.Name].revealtime = p57;
	u40[v153.Name].carrier = p56;
	if u40[v153.Name].dropmodel then
		u40[v153.Name].dropmodel:Destroy();
		u40[v153.Name].dropmodel = nil;
	end;
	if p56 ~= u41 or not char.rootpart then
		u48(p56);
		return;
	end;
	u40.caplight = u31:Clone();
	u40.caplight.Color = v153.Color;
	u40.caplight.Parent = char.rootpart;
end);
network:add("updateflagrecover", function(p58, p59, p60)
	local v154 = u40[p58.Name];
	if v154.dropmodel then
		local l__IsCapping__155 = v154.dropmodel:FindFirstChild("IsCapping");
		local l__CapPoint__156 = v154.dropmodel:FindFirstChild("CapPoint");
		if l__IsCapping__155 and l__CapPoint__156 then
			l__IsCapping__155.Value = p59;
			l__CapPoint__156.Value = p60;
		end;
	end;
end);
local function u50(p61, p62, p63, p64)
	local v157 = u40[p61.Name];
	if v157.dropmodel and v157.dropmodel.Parent then
		local v158 = v157.dropmodel;
	else
		v158 = u33:Clone();
	end;
	local l__Base__159 = v158:FindFirstChild("Base");
	if not l__Base__159 then
		print("no base", v158);
		return;
	end;
	local l__BillboardGui__160 = l__Base__159:FindFirstChild("BillboardGui");
	v158:FindFirstChild("Tag").BrickColor = p61;
	v158.TeamColor.Value = p61;
	l__BillboardGui__160.Display.BackgroundColor = p61;
	l__Base__159:FindFirstChild("PointLight").Color = p61.Color;
	if p61 == u41.TeamColor then
		if p64 then
			local v161 = "Protect";
		else
			v161 = "Dropped";
		end;
		l__BillboardGui__160.Status.Text = v161;
	else
		if p64 then
			local v162 = "Capture";
		else
			v162 = "Pick Up";
		end;
		l__BillboardGui__160.Status.Text = v162;
	end;
	v158:SetPrimaryPartCFrame(p62);
	v158.Location.Value = p62;
	v158.Parent = workspace.Ignore.GunDrop;
	v157.dropmodel = v158;
	v157.droptime = p63;
	v157.dropped = not p64;
	if p64 then
		u40[p61.Name].basecf = p62;
	end;
end;
network:add("dropflag", function(p65, p66, p67, p68, p69)
	u50(p65, p67, p68, p69);
	u43(p65, p66);
end);
local function u51()
	for v163, v164 in next, u42 do
		u43(v164);
		local v165 = u40[v164.Name];
		if v165 and v165.dropmodel then
			v165.dropmodel:Destroy();
			v165.dropmodel = nil;
		end;
	end;
end;
network:add("getrounddata", function(p70)
	print("received game round data");
	local l__ServerSettings__166 = game.ReplicatedStorage.ServerSettings;
	if l__ServerSettings__166.AllowSpawn.Value and l__ServerSettings__166.GameMode.Value == "Capture the Flag" and p70.ctf then
		for v167, v168 in next, u42 do
			local v169 = p70.ctf[v168.Name];
			if v169 and u40[v168.Name] then
				if v169.droptime then
					v169.droptime = network.fromservertick(v169.droptime);
				end;
				if v169.revealtime then
					v169.revealtime = network.fromservertick(v169.revealtime);
				end;
				u40[v168.Name].basecf = v169.basecf;
				if v169.carrier and not v169.dropped then
					u40[v168.Name].carrier = v169.carrier;
					u40[v168.Name].revealtime = v169.revealtime;
					u48(v169.carrier);
				elseif v169.dropped then
					u40[v168.Name].dropped = true;
					u50(v168, v169.dropcf, v169.droptime, false);
				else
					u40[v168.Name].dropped = false;
					u50(v168, v169.basecf, v169.droptime, true);
				end;
			end;
		end;
	end;
end);
trash.Reset:connect(function()
	print("Clearing map");
	workspace.Ignore.GunDrop:ClearAllChildren();
	u51();
end);
u35 = function(p71)
	local v170 = nil;
	local v171 = u24(p71);
	if not v171 then
		return 0, 100;
	end;
	v170 = v171.health0;
	local l__maxhealth__172 = v171.maxhealth;
	if not v171.alive then
		return 0, l__maxhealth__172;
	end;
	local v173 = tick() - v171.healtick0;
	if v173 < 0 then
		return v170, l__maxhealth__172;
	end;
	local v174 = v170 + v173 * v173 * v171.healrate;
	return v174 < l__maxhealth__172 and v174 or l__maxhealth__172, l__maxhealth__172;
end;
u25 = u12.SightFront;
u27 = u12.SightRear;
u31 = u27.ReticleImage;
u32 = function(p72, p73, p74, p75)
	u25.Position = p72;
	u27.Position = p73;
	u25.Size = p74;
	u27.Size = p75;
end;
hud.updatescope = u32;
u32 = function(p76, p77)
	u25.BackgroundColor3 = p77.scopelenscolor or Color3.new(0, 0, 0);
	u25.BackgroundTransparency = p77.scopelenstrans and 1;
	local v175 = p77.scopeimagesize and 1;
	u31.Image = p77.scopeid;
	u31.ImageColor3 = p77.sightcolor and Color3.new(p77.sightcolor.r / 255, p77.sightcolor.g / 255, p77.sightcolor.b / 255) or (p77.scopecolor or Color3.new(1, 1, 1));
	u31.Size = u11(v175, 0, v175, 0);
	u31.Position = u11((1 - v175) / 2, 0, (1 - v175) / 2, 0);
end;
hud.setscopesettings = u32;
u25 = tick;
u25 = u25();
local function u52(p78)
	local v176 = u1.getGunModule(p78);
	if not v176 then
		return;
	end;
	if not v1 then
		return require(v176);
	end;
	return require(v176:Clone());
end;
local u53 = {};
local u54 = l__Use__91;
u27 = function(p79, p80, p81)
	if p80 then
		local v177 = u52(p81);
		if v177 then
			local l__currentgun__178 = u53.currentgun;
			if not l__currentgun__178 then
				return;
			end;
			if u3.controllertype == "controller" then
				local v179 = "Hold Y";
			else
				v179 = "Hold V";
			end;
			u54.Text = v179 .. " to pick up [" .. (v177.displayname and p81) .. "]";
			if v177.type == l__currentgun__178.type or v177.ammotype == l__currentgun__178.ammotype then
				local v180 = tick();
				if u25 < v180 then
					local v181, v182 = l__currentgun__178:dropguninfo();
					if v182 and v182 < l__currentgun__178.sparerounds then
						u25 = v180 + 1;
						network:send("getammo", p80, l__currentgun__178.gunnumber);
						return;
					end;
				end;
			end;
		end;
	else
		u54.Text = "";
	end;
end;
hud.gundrop = u27;
u27 = function(p82)
	return u54.Text ~= "";
end;
hud.getuse = u27;
u27 = function(p83, p84)
	u10.Visible = p84;
end;
hud.enablegamegui = u27;
u27 = function(p85, p86, p87)
	local v183 = u37[p86];
	if not v183 then
		warn("hud object not found");
		return;
	end;
	p87 = p87;
	v183.gui.Visible = p87;
	v183.enabled = p87;
end;
hud.togglehudobj = u27;
u27 = function(p88, p89)
	local v184 = nil;
	if p89 then
		v184 = u24(p89);
		if not v184 then
			return;
		end;
	else
		return;
	end;
	return v184.alive;
end;
hud.isplayeralive = u27;
local u55 = {};
u27 = function(p90, p91)
	return tick() - (u55[p91] and 0);
end;
hud.timesinceplayercombat = u27;
u27 = function(p92, p93)
	if not hud:isplayeralive(p93) then
		return;
	end;
	return replication.getupdater(p93).getpos();
end;
hud.getplayerpos = u27;
u27 = function(p94, p95)
	return u35(p95);
end;
hud.getplayerhealth = u27;
u27 = "Cross";
local u56 = nil;
local u57 = nil;
u31 = function(p96, p97, p98, p99, p100, p101, p102)
	hud.crossspring.t = p98;
	hud.crossspring.s = p99;
	hud.crossspring.d = p100;
	u56 = p101;
	u57 = p102;
	if p97 ~= "SHOTGUN" then
		u27 = "Cross";
		for v185 = 1, 4 do
			local l__next__186 = next;
			local v187, v188 = u18[v185]:GetChildren();
			while true do
				local v189, v190 = l__next__186(v187, v188);
				if not v189 then
					break;
				end;
				v188 = v189;
				v190.Visible = false;			
			end;
		end;
		return;
	end;
	u27 = "Shot";
	for v191 = 1, 4 do
		local l__next__192 = next;
		local v193, v194 = u18[v191]:GetChildren();
		while true do
			local v195, v196 = l__next__192(v193, v194);
			if not v195 then
				break;
			end;
			v194 = v195;
			if v196.Name == u27 then
				v196.Visible = true;
			end;		
		end;
	end;
end;
hud.setcrosssettings = u31;
u31 = function(p103, p104, p105)
	u56 = p104;
	u57 = p105;
end;
hud.updatesightmark = u31;
local u58 = nil;
u31 = function(p106, p107)
	u58 = p107;
end;
hud.updatescopemark = u31;
local u59 = l__Hitmarker__84;
u31 = function()
	if not char.speed or not char.sprint or not u37.crossframe.enabled then
		return;
	end;
	local v197 = hud.crossspring.p * 2 * hud.crossscale.p * (char.speed / 14 * 0.19999999999999996 * 2 + 0.8) * (char.sprint / 2 + 1);
	u14.Visible = false;
	if u27 == "Cross" then
		for v198 = 1, 4 do
			u18[v198].BackgroundTransparency = 1 - v197 / 20;
		end;
	else
		for v199 = 1, 4 do
			u18[v199].BackgroundTransparency = 1;
			local l__next__200 = next;
			local v201, v202 = u18[v199]:GetChildren();
			while true do
				local v203, v204 = l__next__200(v201, v202);
				if not v203 then
					break;
				end;
				v202 = v203;
				if v204.Name == u27 then
					v204.BackgroundTransparency = 1 - v197 / 20 * (v197 / 20);
				end;			
			end;
		end;
	end;
	u18[1].Position = u11(0, v197, 0, 0);
	u18[2].Position = u11(0, -v197 - 7, 0, 0);
	u18[3].Position = u11(0, 0, 0, v197);
	u18[4].Position = u11(0, 0, 0, -v197 - 7);
	local v205 = u9();
	if not u57 and hud.crossspring.t == 0 and u56 and u56.Parent then
		local v206 = camera.currentcamera:WorldToViewportPoint(u56.Position);
		u59.Position = u11(0, v206.x / v205 - 125, 0, v206.y / v205 - 125);
		return;
	end;
	u59.Position = u11(0.5, -125, 0.5, -125);
end;
local u60 = {};
u32 = function(p108, p109)
	local v207 = u60[p109];
	if not v207 then
		return;
	end;
	return v207.Visible;
end;
hud.getplayervisible = u32;
u32 = {};
local u61 = Color3.new;
local u62 = l__NameTag__85;
local u63 = l__Dot__76;
local u64 = Ray.new;
local u65 = {};
u33 = function(p110)
	if p110 == u41 then
		return;
	end;
	local v208 = {};
	u32[p110] = v208;
	local u66 = nil;
	local u67 = nil;
	local function u68(p111)
		if p111 == "TeamColor" and u66 and u66.Parent then
			if p110.TeamColor == u41.TeamColor then
				u66.Visible = true;
				u67.Visible = false;
				u66.TextColor3 = u61(0, 1, 0.9176470588235294);
				u66.Dot.BackgroundTransparency = 1;
				return;
			end;
			u66.Visible = false;
			u67.Visible = false;
			u66.TextColor3 = u61(1, 0.0392156862745098, 0.0784313725490196);
			u66.Dot.BackgroundTransparency = 1;
		end;
	end;
	(function()
		u66 = u15:Clone();
		u66.Text = p110.Name;
		u66.Visible = false;
		u67 = u66:WaitForChild("Health");
		u66.Dot.BackgroundTransparency = 1;
		u66.TextTransparency = 1;
		u66.TextStrokeTransparency = 1;
		u66.Parent = u62;
		u68("TeamColor");
		u60[p110] = u66;
	end)();
	v208[#v208 + 1] = p110.Changed:connect(u68);
	v208[#v208 + 1] = u41.Changed:connect(u68);
	u65[p110] = function()
		local v209 = uiscaler.getscale();
		if not u66.Parent or not u67.Parent then
			return;
		end;
		if hud:isplayeralive(p110) then
			local v210, v211 = replication.getupdater(p110).getpos();
			if v210 and v211 then
				if not ScreenCull.sphere(v210, 4) then
					u66.Visible = false;
					u67.Visible = false;
					return;
				end;
				local l__cframe__212 = camera.cframe;
				local v213 = camera.currentcamera:WorldToScreenPoint(v211 + cframe.vtws(l__cframe__212, Vector3.new(0, 0.625, 0))) / v209;
				local v214 = u63(camera.lookvector, (v210 - l__cframe__212.Position).unit);
				local v215 = (1 / (v214 * v214) - 1) ^ 0.5 * (v210 - l__cframe__212.Position).magnitude;
				u66.Position = u11(0, v213.x - 75, 0, v213.y);
				if p110.TeamColor == u41.TeamColor then
					local v216 = nil;
					local v217 = nil;
					u66.Visible = true;
					u67.Visible = true;
					u66.TextColor3 = u61(0, 1, 0.9176470588235294);
					u66.Dot.BackgroundColor3 = u61(0, 1, 0.9176470588235294);
					v216, v217 = u35(p110);
					if v215 < 4 then
						u66.TextTransparency = 0.125;
						u67.BackgroundTransparency = 0.75;
						u67.Percent.BackgroundTransparency = 0.25;
						u67.Percent.Size = u11(v216 / v217, 0, 1, 0);
						u66.Dot.BackgroundTransparency = 1;
						return;
					elseif v215 < 8 then
						u66.TextTransparency = 0.125 + 0.875 * (v215 - 4) / 4;
						u67.BackgroundTransparency = 0.75 + 0.25 * (v215 - 4) / 4;
						u67.Percent.BackgroundTransparency = 0.25 + 0.75 * (v215 - 4) / 4;
						u67.Percent.Size = u11(v216 / v217, 0, 1, 0);
						u66.Dot.BackgroundTransparency = 1;
						return;
					else
						u66.Dot.BackgroundTransparency = 0.125;
						u66.TextTransparency = 1;
						u67.BackgroundTransparency = 1;
						u67.Percent.BackgroundTransparency = 1;
						return;
					end;
				end;
				u66.Dot.BackgroundTransparency = 1;
				u67.Visible = false;
				u66.TextColor3 = u61(1, 0.0392156862745098, 0.0784313725490196);
				u66.Dot.BackgroundColor3 = u61(1, 0.0392156862745098, 0.0784313725490196);
				if hud:isspotted(p110) and hud:isinsight(p110) then
					u66.Visible = true;
					if v215 < 4 then
						u66.TextTransparency = 0;
						return;
					else
						u66.TextTransparency = 1;
						u66.Dot.BackgroundTransparency = 0;
						return;
					end;
				end;
				if not (not hud:isspotted(p110)) or not (v215 < 4) then
					u66.Visible = false;
					u67.Visible = false;
					return;
				end;
				local l__p__218 = camera.cframe.p;
				local v219 = not workspace:FindPartOnRayWithWhitelist(u64(l__p__218, v210 - l__p__218), roundsystem.raycastwhitelist);
				u66.Visible = v219;
				if v219 then
					if v215 < 2 then
						u66.Visible = true;
						u66.TextTransparency = 0.125;
						return;
					elseif v215 < 4 then
						u66.Visible = true;
						u66.TextTransparency = 0.4375 * v215 - 0.75;
						return;
					else
						u66.Visible = false;
						return;
					end;
				end;
			end;
		else
			u66.Visible = false;
			u67.Visible = false;
		end;
	end;
end;
hud.addnametag = u33;
u34 = function(p112)
	u65[p112] = nil;
	if u60[p112] then
		u60[p112]:Destroy();
	end;
	u60[p112] = nil;
end;
hud.removenametag = u34;
u44 = game;
u46 = "Players";
u42 = u44;
u44 = u44.GetService;
u44 = u44(u42, u46);
u34 = u44.PlayerAdded;
u42 = u33;
u44 = u34;
u34 = u34.connect;
u34(u44, u42);
u44 = game;
u46 = "Players";
u42 = u44;
u44 = u44.GetService;
u44 = u44(u42, u46);
u34 = u44.PlayerRemoving;
u42 = function(p113)
	u36[p113] = nil;
	u55[p113] = nil;
	hud.removenametag(p113);
	local v220 = u32[p113];
	if v220 then
		for v221 = 1, #v220 do
			v220[v221]:Disconnect();
			v220[v221] = nil;
		end;
		u32[p113] = nil;
	end;
end;
u44 = u34;
u34 = u34.connect;
u34(u44, u42);
u34 = next;
u44 = game;
u46 = "Players";
u42 = u44;
u44 = u44.GetService;
u44 = u44(u42, u46);
u42 = u44;
u44 = u44.GetPlayers;
u44, u42 = u44(u42);
while true do
	u46 = u34;
	u47 = u44;
	u40 = u42;
	u46, u47 = u46(u47, u40);
	if not u46 then
		break;
	end;
	u42 = u46;
	u40 = u33;
	u43 = u47;
	u40(u43);
end;
u32 = function()
	for v222, v223 in next, u65 do
		if not v222 or not v222.Parent then
			u65[v222] = nil;
			if u60[v222] then
				u60[v222]:Destroy();
			end;
			u60[v222] = nil;
		else
			u65[v222]();
		end;
	end;
end;
local u69 = l__Capping__86;
u33 = function(p114, p115, p116, p117)
	if p117 == "ctf" then
		local v224 = 100;
	else
		v224 = 50;
	end;
	if not p115 then
		u69.Visible = false;
		return;
	end;
	u69.Visible = true;
	if p117 == "ctf" then
		local v225 = "Recovering...";
	else
		v225 = "Capturing...";
	end;
	u69.Note.Text = v225;
	l__Percent__107.Size = u11(p116 / v224, 0, 1, 0);
end;
hud.capping = u33;
local u70 = l__Bar__95;
u33 = function(p118, p119)
	u70.Size = p119;
end;
hud.setsteadybar = u33;
u33 = function(p120)
	return u70.Size.X.Scale;
end;
hud.getsteadysize = u33;
u33 = function(p121, p122)
	hud.crossscale.t = p122;
end;
hud.setcrossscale = u33;
u33 = function(p123, p124)
	hud.crossspring.t = p124;
end;
hud.setcrosssize = u33;
u33 = nil;
u34 = nil;
u44 = nil;
local u71 = l__Steady__90;
u42 = function(p125, p126, p127)
	u12.Visible = p126;
	u71.Visible = p126 and not p127;
	if u3.controllertype == "controller" then
		local v226 = "Tap LS to Toggle Steady Scope";
	else
		v226 = "Hold Shift to Steady Scope";
	end;
	u71.Text = v226;
	if p126 then
		sound.play("useScope", 0.25);
		u44 = true;
		task.delay(0.5, u33);
	end;
	if not p126 then
		u44 = false;
	end;
end;
hud.setscope = u42;
u33 = function()
	if u44 then
		local v227 = hud:getsteadysize() / 5;
		sound.play("heartBeatIn", 0.05 + v227);
		task.delay(0.3 + v227, u34);
	end;
end;
u34 = function()
	if u44 then
		local v228 = hud:getsteadysize() / 4;
		sound.play("heartBeatOut", 0.05 + v228);
		task.delay(0.5 + v228, u33);
	end;
end;
function hud.updateammo(p128, p129, p130)
	if p129 == "KNIFE" then
		l__Ammo__99.Text = "- - -";
		l__Mag__101.Text = "- - -";
		return;
	end;
	if p129 ~= "GRENADE" then
		l__Ammo__99.Text = p130;
		l__Mag__101.Text = p129;
		return;
	end;
	l__Ammo__99.Text = "- - -";
	l__Mag__101.Text = "- - -";
	l__GAmmo__100.Text = u53.gammo .. "x";
end;
function hud.updatefiremode(p131, p132)
	if p132 == "KNIFE" then
		local v229 = "- - -";
	elseif p132 == true then
		v229 = "AUTO";
	elseif p132 == 1 then
		v229 = "SEMI";
	else
		v229 = "BURST";
	end;
	l__FMode__103.Text = v229;
end;
function hud.firehitmarker(p133, p134)
	hud.hitspring.p = -3;
	if p134 then
		u59.ImageColor3 = Color3.new(1, 0, 0);
		return;
	end;
	u59.ImageColor3 = Color3.new(1, 1, 1);
end;
local l__MiniMapModels__230 = l__ReplicatedStorage__80:WaitForChild("MiniMapModels");
local l__Radar__231 = u10:WaitForChild("Radar");
local l__X__232 = v82.AbsoluteSize.X;
local l__Y__233 = v82.AbsoluteSize.Y;
local l__X__234 = l__Radar__231.AbsoluteSize.X;
local l__Y__235 = l__Radar__231.AbsoluteSize.Y;
local l__Me__236 = l__Radar__231:WaitForChild("Me");
l__Me__236.Size = u11(0, 16, 0, 16);
l__Me__236.Position = u11(0.5, -8, 0.5, -8);
function hud.reset_minimap(p135)

end;
local l__Map__72 = workspace:FindFirstChild("Map");
local u73 = nil;
local u74 = nil;
local u75 = nil;
local l__MiniMapFrame__76 = u10:WaitForChild("MiniMapFrame");
local u77 = nil;
local u78 = l__ReplicatedStorage__80.ServerSettings:WaitForChild("MapName");
local u79 = l__MiniMapModels__230;
local u80 = nil;
local u81 = l__MiniMapModels__230:WaitForChild("Temp");
function hud.set_minimap(p136)
	if l__Map__72 then
		u73 = l__Map__72.PrimaryPart;
		u74 = l__Map__72:FindFirstChild("AGMP");
		u75 = l__MiniMapFrame__76:FindFirstChild("Camera") or u45("Camera");
		u75.FieldOfView = 45;
		l__MiniMapFrame__76.CurrentCamera = u75;
		u75.Parent = l__MiniMapFrame__76;
		if u77 and u77.Name == u78.Value then
			return;
		end;
	else
		print("Did not find map");
		return;
	end;
	if u77 then
		u77:Destroy();
	end;
	local v237 = u79:FindFirstChild(u78.Value);
	if v237 then
		u77 = v237:Clone();
		u77.Parent = l__MiniMapFrame__76;
		u80 = u77.PrimaryPart;
		return;
	end;
	u77 = u81:Clone();
	u77.Parent = l__MiniMapFrame__76;
	u80 = u77.PrimaryPart;
end;
local u82 = nil;
local u83 = {
	players = {}, 
	objectives = {}, 
	rings = {}
};
local u84 = {
	lightred = u61(0.7843137254901961, 0.19607843137254902, 0.19607843137254902), 
	lightblue = u61(0, 0.7843137254901961, 1), 
	green = u61(0, 1, 0.2), 
	red = u61(1, 0, 0)
};
local l__Folder__85 = l__Radar__231:WaitForChild("Folder");
local u86 = {
	players = l__Me__236, 
	objectives = l__Radar__231:WaitForChild("Objective")
};
local function u87(p137)
	local v238, v239 = u75:WorldToViewportPoint((u73.CFrame:inverse() * p137).p * 0.2 + u80.Position);
	local v240 = v238.X;
	local v241 = v238.Y;
	local v242 = 0.5 - v241;
	local v243 = math.atan((v240 - 0.5) / v242) * 180 / math.pi;
	if v242 < 0 then
		v243 = v243 - 180;
	end;
	if v240 > 1 then
		v240 = 1;
	end;
	if v240 < 0 then
		v240 = 0;
	end;
	if v241 > 1 then
		v241 = 1;
	end;
	if v241 < 0 then
		v241 = 0;
	end;
	return v240, v241, math.abs(p137.p.Y - u82.CFrame.p.Y), v239, v243;
end;
local function u88(p138)
	if not u83.rings[p138] then
		local v244 = l__Me__236:Clone();
		v244.Size = UDim2.new(0, 0, 0, 0);
		v244.ImageColor3 = u84.lightred;
		v244.Image = "rbxassetid://2925606552";
		v244.Height.Visible = false;
		v244.Parent = l__Folder__85;
		u83.rings[p138] = v244;
	end;
	return u83.rings[p138];
end;
local function u89(p139, p140)
	if not u83[p140][p139] then
		local v245 = u86[p140]:Clone();
		v245.Size = UDim2.new(0, 14, 0, 14);
		v245.Parent = l__Folder__85;
		u83[p140][p139] = v245;
	end;
	return u83[p140][p139];
end;
local u90 = 0;
local u91 = false;
local u92 = {};
local u93 = {};
function hud.fireradar(p141, p142, p143, p144, p145)
	local v246 = p142.TeamColor ~= u41.TeamColor;
	local v247 = u92[p142];
	if not v247 and v246 then
		v247 = {
			refcf = u21(), 
			shottime = 0, 
			lifetime = 0
		};
		u92[p142] = v247;
	end;
	local v248 = u93[p142];
	if not v248 then
		v248 = {
			refcf = u21(), 
			shottime = 0, 
			lifetime = 0, 
			teamcolor = p142.TeamColor
		};
		u93[p142] = v248;
	end;
	if hud:isplayeralive(p142) then
		v248.refcf = p145;
		v248.teamcolor = p142.TeamColor;
		v248.lifetime = p144.pinglife and 0.5;
		v248.size0 = p144.size0;
		v248.size1 = p144.size1;
		if v248.shottime + v248.lifetime < tick() then
			v248.shottime = tick();
		end;
		if not p143 and v246 then
			v247.refcf = p145;
			v247.lifetime = 5;
			v247.shottime = tick();
		end;
	end;
end;
local u94 = 0;
function hud.set_rel_height(p146)
	if u94 == 0 then
		local v249 = 1;
	else
		v249 = 0;
	end;
	u94 = v249;
end;
function hud.set_minimap_style(p147)
	u91 = not u91;
end;
local u95 = math.pi / 180;
local u96 = {};
local function u97(p148, p149, p150, p151, p152, p153, p154, p155)
	local v250, v251, v252, v253, v254 = u87(p151);
	local v255 = u89(p153, p154);
	local v256 = nil;
	if p154 == "players" then
		if p148 then
			local v257 = "rbxassetid://2911984939";
		else
			v257 = "rbxassetid://3116912054";
		end;
		v255.Image = v257;
		local v258 = p150 == u41.TeamColor and u84.lightblue or u84.red;
		if p149 then
			v258 = u84.green;
		end;
		v255.ImageColor3 = v258;
		v255.Height.ImageColor3 = v255.ImageColor3;
		v255.Height.Visible = not p149 or p148;
		v255.Height.ImageTransparency = p152 and 0;
		local v259, v260, v261 = p151:ToOrientation();
		local v262 = u90;
		if u91 then
			v262 = u73.Orientation.Y;
		end;
		if v253 then
			v255.Rotation = v262 - v260 * 180 / math.pi;
			v255.ImageTransparency = p152 and 0.002 * v252 ^ 2.5;
		else
			v255.Rotation = v254;
			if p148 then
				local v263 = "rbxassetid://2910531391";
			else
				v263 = "rbxassetid://3116912054";
			end;
			v255.Image = v263;
			v255.ImageTransparency = p152 and 0;
		end;
		v255.Size = UDim2.new(0, 14, 0, 14);
	elseif p154 == "objectives" then
		v256 = p150.Color;
		v255.Label.Text = p155;
		v255.Label.TextColor3 = v256;
		v255.Label.Visible = true;
	end;
	v255.ImageColor3 = v256;
	v255.Position = UDim2.new(v250, -14 / 2, v251, -14 / 2);
	v255.Visible = true;
end;
local function u98(p156, p157)
	local v264, v265, v266, v267 = u87(p157.refcf);
	local v268 = u88(p156);
	local v269 = p157.size0 and 4;
	local v270 = (tick() - p157.shottime) / p157.lifetime;
	local v271 = v269 + ((p157.size1 and 30) - v269) * v270;
	v268.ImageColor3 = p157.teamcolor == u41.TeamColor and u84.lightblue or u84.lightred;
	v268.ImageTransparency = v270;
	v268.Size = UDim2.new(0, v271, 0, v271);
	v268.Position = UDim2.new(v264, -v271 / 2, v265, -v271 / 2);
	v268.Visible = true;
end;
local u99 = u37.radar;
local function u100()
	local v272 = l__Folder__85:GetChildren();
	for v273 = 1, #v272 do
		v272[v273].Visible = false;
	end;
	for v274, v275 in next, u96 do
		if not v274.Parent then
			u96[v274] = nil;
		end;
	end;
end;
local function u101()
	local v276 = nil;
	local v277 = nil;
	if not u73 then
		return print("No map found");
	end;
	if not u80 then
		return print("No minimap found");
	end;
	u82 = camera:isspectating() or camera.currentcamera;
	if char.alive then
		l__Me__236.Visible = true;
		l__Me__236.ImageColor3 = u84.lightblue;
	else
		l__Me__236.Visible = camera:isspectating();
		l__Me__236.ImageColor3 = u84.red;
	end;
	l__Me__236.Height.ImageColor3 = l__Me__236.ImageColor3;
	local v278 = (u73.CFrame:inverse() * u82.CFrame).p * 0.2 * Vector3.new(1, u94, 1);
	local v279, v280, v281 = camera.cframe:ToOrientation();
	u90 = v280 * 180 / math.pi;
	v277 = u73.Orientation.Y - u90;
	v276 = v278 + u80.Position;
	if u91 then
		u75.CFrame = u21(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(-90 * u95, 0, 0);
		l__Me__236.Rotation = v277;
	else
		u75.CFrame = u21(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, -v277 * u95, 0) * CFrame.Angles(-90 * u95, 0, 0);
		l__Me__236.Rotation = 0;
	end;
	local v282 = 0;
	local v283 = game:GetService("Players"):GetPlayers();
	for v284 = 1, #v283 do
		local v285 = nil;
		local v286 = v283[v284];
		local v287 = replication.getbodyparts(v286);
		local v288 = u96[v286];
		local v289 = u41 == v286;
		local v290 = hud:isplayeralive(v286) or v289 and char.alive;
		if v287 then
			v285 = v287.rootpart;
		elseif v289 then
			v285 = char.rootpart;
		end;
		if not v288 then
			v288 = {
				lastcf = u21(), 
				alivetick = 0
			};
			u96[v286] = v288;
		end;
		if v285 and v290 then
			v288.lastcf = v285.CFrame;
			v288.alivetick = tick();
		end;
		local v291 = nil;
		local v292 = not v289 and v286.TeamColor == u41.TeamColor;
		if not v290 then
			local v293 = (tick() - v288.alivetick) / 5;
			v291 = math.min(v293 > 0.1 and v293 ^ 0.5 or 0, 1);
			v292 = true;
		elseif not v292 and hud:isspotted(v286) and hud:isinsight(v286) then
			v291 = 0;
			v292 = true;
		end;
		local l__lastcf__294 = v288.lastcf;
		if l__lastcf__294 and v292 then
			v282 = v282 + 1;
			u97(v290, v289, v286.TeamColor, l__lastcf__294, v291, v282, "players");
		end;
	end;
	for v295, v296 in next, u92 do
		local v297 = tick();
		if not v295.Parent then
			u92[v295] = nil;
		elseif v296.shottime + v296.lifetime - v297 > 0 then
			local v298 = hud:isplayeralive(v295);
			local v299 = (tick() - v296.shottime) / v296.lifetime;
			if v298 then
				v282 = v282 + 1;
				u97(v298, false, v295.TeamColor, v296.refcf, v299 > 0.1 and v299 ^ 0.5 or 0, v282, "players");
			end;
		end;
	end;
	local v300 = 0;
	for v301, v302 in next, u93 do
		local v303 = tick();
		if not v301.Parent then
			u93[v301] = nil;
		elseif v302.shottime + v302.lifetime - v303 > 0 then
			v300 = v300 + 1;
			u98(v300, v302);
		end;
	end;
	local v304 = 0;
	if u74 then
		local v305 = u74:GetChildren();
		for v306 = 1, #v305 do
			local v307 = v305[v306];
			local l__Base__308 = v307:FindFirstChild("Base");
			local l__TeamColor__309 = v307:FindFirstChild("TeamColor");
			local l__Letter__310 = v307:FindFirstChild("Letter");
			local v311 = nil;
			if v307.Name == "Flag" then
				v311 = l__Letter__310 and l__Letter__310.Value or "";
			elseif v307.Name == "FlagBase" then
				v311 = "F";
			elseif v307.Name == "HPFlag" then
				v311 = "P";
			end;
			if l__Base__308 then
				v304 = v304 + 1;
				u97(nil, nil, l__TeamColor__309.Value, l__Base__308.CFrame, nil, v304, "objectives", v311);
			end;
		end;
	end;
end;
function hud.radarstep()
	if not u3:isdeployed() then
		return;
	end;
	if u99.enabled then
		u100();
		u101();
	end;
end;
local u102 = 0;
local u103 = l__BloodScreen__87;
u84 = function()
	local v312 = char.gethealth();
	local l__maxhealth__313 = char.maxhealth;
	l__Health__102.Text = v312 + -v312 % 1;
	if v312 < u102 then
		local v314 = u102 - v312;
		u103.ImageTransparency = u103.ImageTransparency - v314 / u102 * 0.7;
		u103.BackgroundTransparency = u103.BackgroundTransparency - v314 / u102 * 0.5 + 0.3;
	elseif u102 < v312 or v312 == l__maxhealth__313 then
		u103.ImageTransparency = u103.ImageTransparency + 0.001;
		u103.BackgroundTransparency = u103.BackgroundTransparency + 0.001;
	elseif v312 <= 0 then
		u103.ImageTransparency = 1;
		u103.BackgroundTransparency = 1;
	end;
	u102 = v312;
	if v312 <= l__maxhealth__313 / 4 then
		l__healthbar_back__104.BackgroundColor3 = v106[4];
		l__healthbar_fill__105.BackgroundColor3 = v106[3];
	else
		l__healthbar_back__104.BackgroundColor3 = v106[1];
		l__healthbar_fill__105.BackgroundColor3 = v106[2];
	end;
	l__healthbar_fill__105.Size = UDim2.new(math.floor(v312) / l__maxhealth__313, 0, 1, 0);
end;
u99 = {};
u95 = {};
u79 = {};
u78 = function(p158)
	local v315 = {};
	if char.alive then
		local l__cframe__316 = camera.cframe;
		local l__unit__317 = l__cframe__316.lookVector.unit;
		local v318 = game:GetService("Players"):GetPlayers();
		local l__TeamColor__319 = u41.TeamColor;
		for v320 = 1, #v318 do
			local v321 = v318[v320];
			if hud:isplayeralive(v321) and v321.TeamColor ~= l__TeamColor__319 then
				local v322 = replication.getbodyparts(v321);
				if v322 and v322.head then
					local v323 = v322.head.Position - camera.cframe.p;
					if u63(l__unit__317, v323.unit) > 0.96592582628 and not workspace:FindPartOnRayWithWhitelist(u64(l__cframe__316.p, v323), roundsystem.raycastwhitelist) then
						u95[v321] = true;
						v315[#v315 + 1] = v321;
					end;
				end;
			end;
		end;
		if #v315 > 0 then
			network:send("spotplayers", v315);
			return true;
		end;
	end;
end;
hud.spot = u78;
u81 = network;
u78 = network.add;
u78(u81, "brokensight", function(p159, p160)
	if p159 then
		u79[p159] = p160;
	end;
end);
u81 = network;
u78 = network.add;
u78(u81, "spotplayer", function(p161)
	if p161 then
		u99[p161] = true;
	end;
end);
u81 = network;
u78 = network.add;
u78(u81, "unspotplayer", function(p162)
	if p162 then
		u99[p162] = nil;
	end;
end);
u78 = function(p163, p164)
	return u99[p164];
end;
hud.isspotted = u78;
u78 = function(p165, p166)
	return not u79[p166] or u95[u41];
end;
hud.isinsight = u78;
local u104 = l__Spotted__93;
u78 = function()
	local l__next__324 = next;
	local v325 = nil;
	while true do
		local v326, v327 = l__next__324(u99, v325);
		if not v326 then
			break;
		end;
		local v328 = false;
		if hud.spectating or char.alive and v326.TeamColor ~= u41.TeamColor then
			local v329 = replication.getbodyparts(v326);
			if v329 and v329.torso and ScreenCull.sphere(v329.torso.Position, 4) and not workspace:FindPartOnRayWithWhitelist(u64(camera.cframe.p, v329.head.Position - camera.cframe.p), roundsystem.raycastwhitelist) then
				v328 = true;
				if not u95[v326] then
					u95[v326] = true;
					network:send("updatesight", v326, true, tick());
				end;
			end;
		end;
		if not v328 and u95[v326] then
			u95[v326] = false;
			network:send("updatesight", v326, false, tick());
		end;	
	end;
	if hud:isspotted(u41) then
		u104.Visible = true;
		if hud:isinsight(u41) then
			u104.Text = "Spotted by enemy!";
			u104.TextColor3 = Color3.new(1, 0.125, 0.125);
			return;
		else
			u104.Text = "Hiding from enemy...";
			u104.TextColor3 = Color3.new(0.125, 1, 0.125);
			return;
		end;
	end;
	local l__Spottimer__330 = u104:FindFirstChild("Spottimer");
	if not l__Spottimer__330 or not (l__Spottimer__330.Timer.Value > 0) then
		u104.Visible = false;
		return;
	end;
	u104.Visible = true;
	u104.Text = "On Radar!";
	u104.TextColor3 = Color3.new(1, 0.8, 0);
end;
hud.spotstep = u78;
u78 = function(p167)
	local l__Spottimer__331 = u104:FindFirstChild("Spottimer");
	if not l__Spottimer__331 then
		local v332 = u45("Model");
		v332.Name = "Spottimer";
		local v333 = u45("IntValue");
		v333.Name = "Timer";
		v333.Parent = v332;
		v332.Parent = u104;
	else
		v333 = l__Spottimer__331.Timer;
	end;
	if v333.Value <= 30 then
		local v334 = 30;
	elseif v333.Value + 30 > 200 then
		v334 = 200;
	else
		v334 = v333.Value + 30;
	end;
	v333.Value = v334;
end;
hud.goingloud = u78;
u79 = "shot";
local u105 = l__Misc__81.BloodArc;
u78 = function(p168, p169, p170)
	local v335 = u10:GetChildren();
	for v336 = 1, #v335 do
		if v335[v336].Name == "BloodArc" and v335[v336].Player.Value == p168.Name then
			v335[v336]:Destroy();
		end;
	end;
	local v337 = u105:Clone();
	v337.Pos.Value = p169;
	v337.Player.Value = p168.Name;
	v337.Parent = u10;
	camera:hit((-p170 / 12 + 4.166666666666667) * (camera.cframe.p - p169).unit);
end;
u95 = network;
u99 = network.add;
u99(u95, u79, u78);
u79 = "updatecombat";
u78 = function(p171)
	if p171 then
		u55[p171] = tick();
	end;
end;
u95 = network;
u99 = network.add;
u99(u95, u79, u78);
local u106 = {};
local u107 = v82;
u99 = function(p172)
	hud:reset_minimap();
	hud:set_minimap();
	hud:setscope(false);
	effects:reload();
	u106:reset();
	particle:reset();
	local v338 = u10:GetChildren();
	for v339 = 1, #v338 do
		if v338[v339].Name == "BloodArc" then
			v338[v339]:Destroy();
		end;
	end;
	local l__KillBar__340 = u107:FindFirstChild("KillBar");
	if l__KillBar__340 then
		l__KillBar__340:Destroy();
	end;
end;
hud.reloadhud = u99;
u99 = function()
	u32();
	u84();
end;
hud.beat = u99;
local u108 = 0;
local u109 = 0;
u99 = function()
	u59.ImageTransparency = hud.hitspring.p;
	if u10.Visible then
		local v341 = tick();
		u31();
		if u108 + 0.016666666666666666 < v341 then
			hud.gamemoderenderstep();
			u108 = v341 + 0.016666666666666666;
		end;
		if u109 + 0.1 < v341 then
			hud.spotstep();
			hud.gamemodestep();
			local l__Spottimer__342 = u104:FindFirstChild("Spottimer");
			if l__Spottimer__342 and l__Spottimer__342.Timer.Value > 0 then
				l__Spottimer__342.Timer.Value = l__Spottimer__342.Timer.Value - 1;
			end;
			u109 = v341 + 0.1;
		end;
	end;
	hud.votestep();
end;
hud.step = u99;
u9 = print;
u11 = "Loading notify module";
u9(u11);
u9 = uiscaler.getscale;
u21 = game;
u11 = u21.WaitForChild;
u13 = game;
u21 = u13.FindFirstChild;
u13 = UDim2.new;
u61 = Vector3.new;
u63 = Color3.new;
u45 = Vector3.new;
u45 = u45();
u64 = u45.Dot;
u45 = Ray.new;
local v343 = workspace.FindPartOnRayWithIgnoreList;
u15 = game;
u16 = u15;
u15 = u15.GetService;
u15 = u15(u16, "Players");
u41 = u15.LocalPlayer;
u16 = game;
u15 = u16.ReplicatedStorage;
u16 = u15.Misc;
local l__PlayerGui__344 = u41.PlayerGui;
u105 = l__PlayerGui__344;
u8 = "MainGui";
local v345 = u11(u105, u8);
u105 = u11;
u8 = v345;
u20 = "GameGui";
u105 = u105(u8, u20);
u8 = u11;
u20 = u105;
u39 = "NotifyList";
u8 = u8(u20, u39);
u20 = u16.Main;
u39 = u16.Side;
u107 = u16.KillBar;
u10 = u16.RankBar;
u14 = {};
u18 = {};
u7 = "Enemy Killed!";
u18[1] = u7;
u14.kill = u18;
u18 = {};
u7 = "Double Collateral!";
u18[1] = u7;
u14.collx2 = u18;
u18 = {};
u7 = "Triple Collateral!";
u18[1] = u7;
u14.collx3 = u18;
u18 = {};
u7 = "Multi Collateral!";
u18[1] = u7;
u14.collxn = u18;
u18 = {};
u7 = "Double Kill!";
u18[1] = u7;
u14.killx2 = u18;
u18 = {};
u7 = "Triple Kill!";
u18[1] = u7;
u14.killx3 = u18;
u18 = {};
u7 = "Quad Kill!";
u18[1] = u7;
u14.killx4 = u18;
u18 = {};
u7 = "Multi Kill!";
u18[1] = u7;
u14.killxn = u18;
u18 = {};
u7 = "Backstab!";
u18[1] = u7;
u14.backstab = u18;
u18 = {};
u7 = "Assist!";
u18[1] = u7;
u14.assist = u18;
u18 = {};
u7 = "Suppressed Enemy!";
u18[1] = u7;
u14.suppression = u18;
u18 = {};
u7 = "Assist Count As Kill!";
u18[1] = u7;
u14.assistkill = u18;
u18 = {};
u7 = "Headshot Bonus!";
u18[1] = u7;
u14.head = u18;
u18 = {};
u7 = "Wallbang Bonus!";
u18[1] = u7;
u14.wall = u18;
u18 = {};
u7 = "Spot Bonus!";
u18[1] = u7;
u14.spot = u18;
u18 = {};
u7 = "Killed from a distance!";
u12 = "Long Shot!";
u18[1] = u7;
u18[2] = u12;
u14.long = u18;
u18 = {};
u7 = "Teammate spawned on you";
u12 = "Squadmate spawned on you";
u18[1] = u7;
u18[2] = u12;
u14.squad = u18;
u18 = {};
u7 = "Acquired Enemy Flag!";
u12 = "Stolen Enemy Flag!";
u18[1] = u7;
u18[2] = u12;
u14.flagsteal = u18;
u18 = {};
u7 = "Captured Enemy Flag!";
u18[1] = u7;
u14.flagcapture = u18;
u18 = {};
u7 = "Team Captured Enemy Flag!";
u18[1] = u7;
u14.flagteamcap = u18;
u18 = {};
u7 = "Recovered Team Flag!";
u18[1] = u7;
u14.flagrecover = u18;
u18 = {};
u7 = "Killed Enemy Flag Carrier!";
u18[1] = u7;
u14.flagdef1 = u18;
u18 = {};
u7 = "Protected Flag Carrier!";
u18[1] = u7;
u14.flagdef2 = u18;
u18 = {};
u7 = "Denied Enemy Capture!";
u18[1] = u7;
u14.flagdef3 = u18;
u18 = {};
u7 = "Denied Enemy Pick Up!";
u18[1] = u7;
u14.flagdef4 = u18;
u18 = {};
u7 = "Flag Guard Kill!";
u18[1] = u7;
u14.flagdef5 = u18;
u18 = {};
u7 = "Flag Recover Kill!";
u18[1] = u7;
u14.flagdef6 = u18;
u18 = {};
u7 = "Flag Escort Kill!";
u18[1] = u7;
u14.flagsup1 = u18;
u18 = {};
u7 = "Killed Enemy Flag Escort!";
u18[1] = u7;
u14.flagsup2 = u18;
u18 = {};
u7 = "Assisted by Teammate!";
u18[1] = u7;
u14.flagsup3 = u18;
u18 = {};
u7 = "Protected Flag Carrier Under Fire!";
u12 = "Protected Flag Carrier!";
u18[1] = u7;
u18[2] = u12;
u14.flagsup4 = u18;
u18 = {};
u7 = "Saved by Teammate!";
u18[1] = u7;
u14.flagsup5 = u18;
u18 = {};
u7 = "Protected by Teammate!";
u18[1] = u7;
u14.flagsup6 = u18;
u18 = {};
u7 = "Offensive Flag Kill!";
u18[1] = u7;
u14.flagoff1 = u18;
u18 = {};
u7 = "Denied Enemy Flag Recovery!";
u18[1] = u7;
u14.flagoff2 = u18;
u18 = {};
u7 = "Killed Enemy Flag Guard!";
u18[1] = u7;
u14.flagoff3 = u18;
u18 = {};
u7 = "Secured Personal Tag!";
u18[1] = u7;
u14.dogtagself = u18;
u18 = {};
u7 = "Kill Confirmed!";
u18[1] = u7;
u14.dogtagconfirm = u18;
u18 = {};
u7 = "Teammate Confirmed Kill!";
u18[1] = u7;
u14.dogtagteam = u18;
u18 = {};
u7 = "Denied Enemy Kill!";
u18[1] = u7;
u14.dogtagdeny = u18;
u18 = {};
u7 = "Captured a position!";
u18[1] = u7;
u14.domcap = u18;
u18 = {};
u7 = "Capturing position";
u18[1] = u7;
u14.domcapping = u18;
u18 = {};
u7 = "Defended a position!";
u18[1] = u7;
u14.domdefend = u18;
u18 = {};
u7 = "Assaulted a position!";
u18[1] = u7;
u14.domassault = u18;
u18 = {};
u7 = "Attacked a position!";
u18[1] = u7;
u14.domattack = u18;
u18 = {};
u7 = "Stopped an enemy capture!";
u18[1] = u7;
u14.dombuzz = u18;
u18 = {};
u7 = "Captured the hill!";
u18[1] = u7;
u14.kingcap = u18;
u18 = {};
u7 = "Holding hill";
u18[1] = u7;
u14.kingholding = u18;
u18 = {};
u7 = "Capturing hill";
u18[1] = u7;
u14.kingcapping = u18;
u18 = {};
u7 = "Holding point!";
u12 = "Holding position!";
u18[1] = u7;
u18[2] = u12;
u14.hphold = u18;
u18 = {};
u7 = "Defended position!";
u12 = "Defended point!";
u18[1] = u7;
u18[2] = u12;
u14.hpdefend = u18;
u18 = {};
u7 = "Assaulted point!";
u12 = "Assaulted position!";
u18[1] = u7;
u18[2] = u12;
u14.hpassault = u18;
u18 = {};
u7 = "Attacked position!";
u12 = "Attacked point!";
u18[1] = u7;
u18[2] = u12;
u14.hpattack = u18;
u18 = {};
u14[" "] = u18;
u18 = function(p173, p174)
	p173.AutoLocalize = false;
	p173.Text = "";
	local l__Text__110 = p173.Text;
	local u111 = p174 and 2;
	task.spawn(function()
		local v346 = 1;
		for v347, v348 in utf8.graphemes(l__Text__110) do
			p173.Text = p173.Text .. l__Text__110:sub(v347, v348);
			if v346 * u111 < v347 then
				sound.play("ui_typeout", 0.2);
				v346 = v346 + 1;
				task.wait(0.016666666666666666);
			end;
		end;
	end);
end;
u7 = function(p175, p176)
	p175.AutoLocalize = false;
	local v349 = p176 and 3;
	local l__Text__350 = p175.Text;
	p175.Text = "";
	local v351 = 1;
	for v352, v353 in utf8.graphemes(l__Text__350) do
		p175.Text = p175.Text .. l__Text__350:sub(v352, v353);
		if v351 * v349 < v352 then
			sound.play("ui_typeout", 0.2);
			v351 = v351 + 1;
			task.wait(0.016666666666666666);
		end;
	end;
end;
u12 = function(p177, p178)
	local v354 = u39:Clone();
	local v355 = u11(v354, "Primary");
	v354.Parent = u8;
	sound.play("ui_smallaward", 0.2);
	local v356 = u8:GetChildren();
	for v357 = 1, #v356 do
		local v358 = v356[v357];
		if v358:IsA("Frame") and v358.Parent then
			v358:TweenPosition(u13(0, 0, 0, (#v356 - v357) * 20), "Out", "Sine", 0.05, true);
		end;
	end;
	task.spawn(function()
		v355.Text = p178;
		v355.TextTransparency = 0;
		u18(v355, 3);
		task.wait(5.5);
		for v359 = 1, 10 do
			v355.TextTransparency = v359 / 10;
			v355.TextStrokeTransparency = v359 / 10 + 0.4;
			task.wait(0.016666666666666666);
		end;
		task.wait(0.1);
		v354:Destroy();
	end);
end;
u106.customaward = u12;
local l__AttachBar__112 = u16.AttachBar;
local u113 = v345;
u12 = function(p179, p180)
	local v360 = l__AttachBar__112:Clone();
	local l__Title__361 = v360.Title;
	local l__Attach__362 = v360.Attach;
	v360.Position = u13(0.5, 0, 0.15, 0);
	l__Title__361.Text = p179;
	l__Attach__362.Text = p180;
	v360.Parent = u113;
	local l__RenderStepped__363 = game:GetService("RunService").RenderStepped;
	local u114 = tick() + 6;
	local u115 = nil;
	u115 = l__RenderStepped__363:connect(function()
		local v364 = u114 - tick();
		if v364 < 5 then
			local v365 = 0;
		else
			v365 = v364 < 5.5 and (v364 - 5) / 0.5 or 1;
		end;
		l__Attach__362.TextTransparency = v365;
		if v364 < 5 then
			local v366 = 0;
		else
			v366 = v364 < 5.5 and (v364 - 5) / 0.5 or 1;
		end;
		l__Title__361.TextTransparency = v366;
		if v364 <= 0 then
			u115:disconnect();
			v360:Destroy();
		end;
	end);
end;
u59 = function(p181, p182)
	local v367 = u39:Clone();
	local v368 = u11(v367, "Primary");
	local v369 = u11(v367, "Point");
	sound.play("ui_smallaward", 0.2);
	v367.Parent = u8;
	local v370 = u8:GetChildren();
	for v371 = 1, #v370 do
		local v372 = v370[v371];
		if v372:IsA("Frame") and v372.Parent then
			v372:TweenPosition(u13(0, 0, 0, (#v370 - v371) * 20), "Out", "Sine", 0.05, true);
		end;
	end;
	v369.Text = "[+" .. (p182 and 25) .. "]";
	local v373 = u14[p181];
	if #v373 > 1 then
		v368.Text = v373[math.random(1, #v373)];
	else
		v368.Text = v373[1];
	end;
	if p181 == "head" then
		sound.play("headshotkill", 0.45);
	end;
	v369.TextTransparency = 0;
	v368.TextTransparency = 0;
	u18(v369, 3);
	u18(v368, 3);
	task.wait(5.5);
	for v374 = 1, 10 do
		v369.TextTransparency = v374 / 10;
		v368.TextTransparency = v374 / 10;
		v369.TextStrokeTransparency = v374 / 10 + 0.4;
		v368.TextStrokeTransparency = v374 / 10 + 0.4;
		task.wait(0.016666666666666666);
	end;
	task.wait(0.1);
	v367:Destroy();
end;
u62 = function(p183, p184, p185, p186)
	local v375 = u20:Clone();
	local v376 = u11(v375, "Overlay");
	local v377 = u11(v375, "Primary");
	local v378 = u11(v375, "Point");
	local v379 = u11(v375, "Enemy");
	local v380 = u9();
	v375.Parent = u8;
	local v381 = u8:GetChildren();
	for v382 = 1, #v381 do
		local v383 = v381[v382];
		if v383:IsA("Frame") and v383.Parent then
			v383:TweenPosition(u13(0, 0, 0, (#v381 - v382) * 20), "Out", "Sine", 0.05, true);
		end;
	end;
	v378.Text = "[+" .. p186 .. "]";
	local v384 = u14[p183];
	if #v384 > 1 then
		v377.Text = v384[math.random(1, #v384)];
	else
		v377.Text = v384[1];
	end;
	v379.Text = p184.Name and "";
	v379.TextColor3 = p184.TeamColor.Color;
	sound.play("ui_begin", 0.4);
	if p183 == "kill" then
		sound.play("killshot", 0.2);
	end;
	v378.TextTransparency = 0;
	v378.TextStrokeTransparency = 0;
	v377.TextTransparency = 0;
	v377.TextStrokeTransparency = 0;
	v379.TextTransparency = 1;
	v379.TextStrokeTransparency = 1;
	v376.ImageTransparency = 0.2;
	v376:TweenSizeAndPosition(u13(0, 200, 0, 80), u13(0.5, -150, 0.7, -40), "Out", "Linear", 0, true);
	u18(v378);
	u18(v377);
	task.delay(0.05, function()
		for v385 = 1, 10 do
			v376.ImageTransparency = v385 / 10;
			task.wait(0.1);
		end;
		v376.Size = u13(0, 200, 0, 80);
		v376.Position = u13(0.55, -100, 0.3, -40);
	end);
	v376:TweenSizeAndPosition(u13(0, 300, 0, 30), u13(0.5, -150, 0.7, -15), "Out", "Linear", 0.05, true);
	task.wait(0.05);
	v376:TweenSizeAndPosition(u13(0, 500, 0, 8), u13(0.5, -150, 0.7, -4), "Out", "Linear", 0.05, true);
	task.wait(1.5);
	for v386 = 1, 2 do
		v377.TextTransparency = 1;
		v377.TextStrokeTransparency = 1;
		sound.play("ui_blink", 0.4);
		task.wait(0.1);
		v377.TextTransparency = 0;
		v377.TextStrokeTransparency = 0;
		task.wait(0.1);
	end;
	v377.TextTransparency = 1;
	v377.TextStrokeTransparency = 1;
	task.wait(0.2);
	v379.TextTransparency = 0;
	v379.TextStrokeTransparency = 0;
	u7(v379, 4);
	v377.TextTransparency = 0;
	v377.TextStrokeTransparency = 0;
	v377.Position = u13(0.5, v379.TextBounds.x / v380 + 10, 0.7, -10);
	if p183 == "kill" then
		v377.Text = "[" .. p185 .. "]";
	else
		v377.Text = p185;
	end;
	u7(v377, 4);
	task.wait(3);
	for v387 = 1, 10 do
		v378.TextTransparency = v387 / 10;
		v377.TextTransparency = v387 / 10;
		v379.TextTransparency = v387 / 10;
		v378.TextStrokeTransparency = v387 / 10 + 0.4;
		v377.TextStrokeTransparency = v387 / 10 + 0.4;
		v379.TextStrokeTransparency = v387 / 10 + 0.4;
		task.wait(0.016666666666666666);
	end;
	task.wait(0.1);
	v375:Destroy();
end;
u69 = function(p187)
	local v388 = l__AttachBar__112:Clone();
	local l__Title__389 = v388.Title;
	local l__Attach__390 = v388.Attach;
	v388.Position = u13(0.5, 0, 0.15, 0);
	v388.Parent = u113;
	l__Title__389.Text = "Unlocked New Weapon!";
	l__Attach__390.Text = p187;
	local u116 = tick();
	local u117 = nil;
	u117 = game:GetService("RunService").RenderStepped:connect(function()
		local v391 = tick() - u116;
		if v391 < 2 then
			local v392 = 0;
		else
			v392 = v391 < 2.5 and (v391 - 2) / 0.5 or 1;
		end;
		l__Attach__390.TextTransparency = v392;
		if v391 < 2 then
			local v393 = 0;
		else
			v393 = v391 < 2.5 and (v391 - 2) / 0.5 or 1;
		end;
		l__Title__389.TextTransparency = v393;
		if v391 > 3 then
			u117:disconnect();
			v388:Destroy();
		end;
	end);
end;
u103 = function(p188, p189, p190)
	for v394 = 1, #p189 do
		local v395 = p190[v394];
		local v396 = l__AttachBar__112:Clone();
		local l__Money__397 = v396.Money;
		local l__Title__398 = v396.Title;
		local l__Attach__399 = v396.Attach;
		v396.Position = u13(0.5, 0, 0.15, 0);
		v396.Parent = u113;
		l__Title__398.Text = "Unlocked " .. p188 .. " Attachment";
		l__Attach__399.Text = p189[v394];
		l__Money__397.Text = "[+200]";
		local u118 = tick();
		local u119 = nil;
		u119 = game:GetService("RunService").RenderStepped:connect(function()
			local v400 = tick() - u118;
			if v400 < 2 then
				local v401 = 0;
			else
				v401 = v400 < 2.5 and (v400 - 2) / 0.5 or 1;
			end;
			l__Attach__399.TextTransparency = v401;
			if v400 < 2 then
				local v402 = 0;
			else
				v402 = v400 < 2.5 and (v400 - 2) / 0.5 or 1;
			end;
			l__Title__398.TextTransparency = v402;
			if v400 < 0.5 then
				local v403 = 1;
			elseif v400 < 2.5 then
				v403 = 0;
			else
				v403 = v400 < 3 and (v400 - 2.5) / 0.5 or 1;
			end;
			l__Money__397.TextTransparency = v403;
			if v400 > 3 then
				u119:disconnect();
				v396:Destroy();
			end;
		end);
		task.wait(3);
	end;
end;
local u120 = l__PlayerGui__344;
u38 = function(p191)
	u113 = u11(u120, "MainGui");
	u105 = u11(u113, "GameGui");
	u8 = u11(u105, "NotifyList");
	if u21(u113, "KillBar") then
		u113.KillBar:Destroy();
	end;
end;
u106.reset = u38;
u54 = "unlockweapon";
u71 = network;
u38 = network.add;
u38(u71, u54, u69);
u38 = nil;
u71 = CFrame.new;
u54 = u71().toObjectSpace;
u104 = game.ReplicatedStorage;
local u121 = Instance.new;
local u122 = BrickColor.new;
u70 = function(p192, p193, p194, p195)
	local l__next__404 = next;
	local v405, v406 = p192:GetChildren();
	while true do
		local v407, v408 = l__next__404(v405, v406);
		if not v407 then
			break;
		end;
		if p195 and v408:IsA("BasePart") and v408.Name == "LaserLight" then
			v408.Material = "SmoothPlastic";
			if u21(v408, "Bar") then
				v408.Bar.Scale = Vector3.new(0.1, 1000, 0.1);
			end;
		end;
		if not (not u21(v408, "Mesh")) or not (not v408:IsA("UnionOperation")) or v408:IsA("MeshPart") then
			v408.Anchored = true;
			local v409 = u21(v408, "Slot1") or u21(v408, "Slot2");
			if v409 then
				local l__next__410 = next;
				local v411, v412 = v408:GetChildren();
				while true do
					local v413, v414 = l__next__410(v411, v412);
					if not v413 then
						break;
					end;
					v412 = v413;
					if v414:IsA("Texture") then
						v414:Destroy();
					end;				
				end;
				if p194 and p194[v409.Name] and p194[v409.Name].Name ~= "" then
					local l__BrickProperties__415 = p194[v409.Name].BrickProperties;
					local l__TextureProperties__416 = p194[v409.Name].TextureProperties;
					local v417 = u121("Texture");
					v417.Name = v409.Name;
					v417.Texture = "rbxassetid://" .. l__TextureProperties__416.TextureId;
					if v408.Transparency >= 0.8 then
						local v418 = 1;
					else
						v418 = l__TextureProperties__416.Transparency or 0;
					end;
					v417.Transparency = v418;
					v417.StudsPerTileU = l__TextureProperties__416.StudsPerTileU and 1;
					v417.StudsPerTileV = l__TextureProperties__416.StudsPerTileV and 1;
					v417.OffsetStudsU = l__TextureProperties__416.OffsetStudsU and 0;
					v417.OffsetStudsV = l__TextureProperties__416.OffsetStudsV and 0;
					if l__TextureProperties__416.Color then
						local l__Color__419 = l__TextureProperties__416.Color;
						v417.Color3 = Color3.new(l__Color__419.r / 255, l__Color__419.g / 255, l__Color__419.b / 255);
					end;
					if v408:IsA("MeshPart") or v408:IsA("UnionOperation") then
						local v420 = 5;
					else
						v420 = 0;
					end;
					for v421 = 0, v420 do
						local v422 = v417:Clone();
						v422.Face = v421;
						v422.Parent = v408;
					end;
					v417:Destroy();
					if not l__BrickProperties__415.DefaultColor then
						if v408:IsA("UnionOperation") then
							v408.UsePartColor = true;
						end;
						if l__BrickProperties__415.Color then
							local l__Color__423 = l__BrickProperties__415.Color;
							v408.Color = Color3.new(l__Color__423.r / 255, l__Color__423.g / 255, l__Color__423.b / 255);
						elseif l__BrickProperties__415.BrickColor then
							v408.BrickColor = u122(l__BrickProperties__415.BrickColor);
						end;
					end;
					if l__BrickProperties__415.Material then
						v408.Material = l__BrickProperties__415.Material;
					end;
					if l__BrickProperties__415.Reflectance then
						v408.Reflectance = l__BrickProperties__415.Reflectance;
					end;
				end;
			end;
		elseif v408:IsA("Model") then
			u70(v408, p193, p194, p195);
		end;	
	end;
end;
local l__AttachmentModels__123 = u104.AttachmentModels;
local function u124(p196, p197, p198)
	local v424 = p196:GetChildren();
	local v425 = nil;
	for v426 = 1, #v424 do
		if p197 == "Optics" then
			if v424[v426].Name == "Iron" or v424[v426].Name == "IronGlow" then
				if p198 and not u21(v424[v426], "Hide") then
					local v427 = u121("IntValue");
					v427.Name = "Hide";
					v427.Parent = v424[v426];
				else
					local v428 = u21(v424[v426], "Hide");
					if v428 then
						v428:Destroy();
					end;
				end;
				if p198 then
					local v429 = 1;
				else
					v429 = 0;
				end;
				v424[v426].Transparency = v429;
			elseif v424[v426].Name == "SightMark" and u21(v424[v426], "Decal") then
				if p198 then
					local v430 = 1;
				else
					v430 = 0;
				end;
				v424[v426].Decal.Transparency = v430;
			end;
		elseif p197 == "Underbarrel" then
			if v424[v426].Name == "Grip" then
				if p198 and not u21(v424[v426], "Hide") then
					local v431 = u121("IntValue");
					v431.Name = "Hide";
					v431.Parent = v424[v426];
				else
					local v432 = u21(v424[v426], "Hide");
					if v432 then
						v432:Destroy();
					end;
				end;
				if p198 then
					local v433 = 1;
				else
					v433 = 0;
				end;
				v424[v426].Transparency = v433;
				v425 = u21(v424[v426], "Slot1") or u21(v424[v426], "Slot2");
			end;
		elseif p197 == "Barrel" and v424[v426].Name == "Barrel" then
			if p198 and not u21(v424[v426], "Hide") then
				local v434 = u121("IntValue");
				v434.Name = "Hide";
				v434.Parent = v424[v426];
			else
				local v435 = u21(v424[v426], "Hide");
				if v435 then
					v435:Destroy();
				end;
			end;
			if p198 then
				local v436 = 1;
			else
				v436 = 0;
			end;
			v424[v426].Transparency = v436;
			v425 = u21(v424[v426], "Slot1") or u21(v424[v426], "Slot2");
		end;
	end;
	return v425;
end;
local l__getGunModel__125 = u1.getGunModel;
local function u126(p199, p200, p201, p202, p203)
	local v437 = p199:GetChildren();
	local v438 = u52(p199.Name);
	local v439 = v438.attachments[p200] and v438.attachments[p200][p201] or {};
	local v440 = v439.altmodel and u21(l__AttachmentModels__123, v439.altmodel) or u21(l__AttachmentModels__123, p201);
	if not v440 then
		return;
	end;
	local v441 = v440:Clone();
	local v442 = u11(v441, "Node");
	local v443 = v439.sidemount and l__AttachmentModels__123[v439.sidemount]:Clone();
	v441.Name = p201;
	if v443 then
		local l__Node__444 = v443.Node;
		if v439.mountnode then
			local v445 = p202[v439.mountnode];
			if not v445 then
				if p200 == "Optics" then
					v445 = p202.MountNode;
					if not v445 then
						v445 = false;
						if p200 == "Underbarrel" then
							v445 = p202.UnderMountNode;
						end;
					end;
				else
					v445 = false;
					if p200 == "Underbarrel" then
						v445 = p202.UnderMountNode;
					end;
				end;
			end;
		elseif p200 == "Optics" then
			v445 = p202.MountNode;
			if not v445 then
				v445 = false;
				if p200 == "Underbarrel" then
					v445 = p202.UnderMountNode;
				end;
			end;
		else
			v445 = false;
			if p200 == "Underbarrel" then
				v445 = p202.UnderMountNode;
			end;
		end;
		local v446 = {};
		local v447 = v443:GetChildren();
		local l__CFrame__448 = l__Node__444.CFrame;
		for v449 = 1, #v447 do
			if v447[v449]:IsA("BasePart") then
				v446[v449] = u54(l__CFrame__448, v447[v449].CFrame);
			end;
		end;
		l__Node__444.CFrame = v445.CFrame;
		for v450 = 1, #v447 do
			if v447[v450]:IsA("BasePart") then
				v447[v450].CFrame = v445.CFrame * v446[v450];
			end;
		end;
		local v451 = v439.node and p202[v439.node] or v443[p200 .. "Node"];
		v443.Parent = v441;
	else
		v451 = v439.node and p202[v439.node] or p202[p200 .. "Node"];
	end;
	if v439.auxmodels then
		local v452 = {};
		local l__next__453 = next;
		local l__auxmodels__454 = v439.auxmodels;
		local v455 = nil;
		while true do
			local v456, v457 = l__next__453(l__auxmodels__454, v455);
			if not v456 then
				break;
			end;
			local v458 = v457.Name or p201 .. " " .. v457.PostName;
			local v459 = l__AttachmentModels__123[v458]:Clone();
			local l__Node__460 = v459.Node;
			v452[v458] = v459;
			if v457.sidemount and v443 then
				local v461 = v443[v457.Node];
			elseif v457.auxmount and v452[v457.auxmount] and u21(v452[v457.auxmount], v457.Node) then
				v461 = v452[v457.auxmount][v457.Node];
			else
				v461 = p202[v457.Node];
			end;
			if v457.mainnode then
				v451 = v459[v457.mainnode];
			end;
			local v462 = {};
			local v463 = v459:GetChildren();
			local l__CFrame__464 = l__Node__460.CFrame;
			for v465 = 1, #v463 do
				if v463[v465]:IsA("BasePart") then
					v462[v465] = u54(l__CFrame__464, v463[v465].CFrame);
				end;
			end;
			l__Node__460.CFrame = v461.CFrame;
			for v466 = 1, #v463 do
				if v463[v466]:IsA("BasePart") then
					v463[v466].CFrame = v461.CFrame * v462[v466];
				end;
			end;
			v459.Parent = v441;		
		end;
	end;
	local v467 = {};
	local v468 = v441:GetChildren();
	local v469 = v442 and v442.CFrame;
	local v470 = u124(p199, p200, true);
	for v471 = 1, #v468 do
		if v468[v471]:IsA("BasePart") then
			v467[v471] = u54(v469, v468[v471].CFrame);
		end;
	end;
	for v472 = 1, #v437 do
		local v473 = v437[v472];
		if v439.transparencymod and v439.transparencymod[v473.Name] then
			local v474 = u121("IntValue");
			v474.Parent = v473;
			v474.Name = p200 .. "Hide";
			v474.Value = v473.Transparency;
			v473.Transparency = v439.transparencymod[v473.Name];
		end;
	end;
	v442.CFrame = v451.CFrame;
	for v475 = 1, #v468 do
		if v468[v475]:IsA("BasePart") then
			local v476 = v468[v475];
			v476.CFrame = v451.CFrame * v467[v475];
			if v470 and (not (not u21(v476, "Mesh")) or not (not v476:IsA("UnionOperation")) or v476:IsA("MeshPart")) then
				v470:Clone().Parent = v476;
			end;
		end;
	end;
	v441.Parent = p199;
end;
u38 = function(p204, p205, p206)
	local v477 = l__getGunModel__125(p204);
	if not v477 then
		network:send("debug", "Failed to find weapon model for", p204);
		error("Failed to find weapon model for", p204);
		return;
	end;
	local v478 = v477:Clone();
	local v479 = u11(v478, "MenuNodes");
	v479.Parent = v478;
	v478.PrimaryPart = u11(v479, "MenuNode");
	if p205 then
		for v480, v481 in next, p205 do
			if v481 ~= "" then
				u126(v478, v480, v481, v479);
			end;
		end;
	end;
	u70(v478, p205, p206, true);
	return v478;
end;
u122 = "killed";
u104 = function(p207, p208, p209, p210, p211, p212, p213)
	local l__cframe__482 = camera.cframe;
	if p207 == u41 then
		camera:setfixedcam(CFrame.new(l__cframe__482.p, l__cframe__482.p + l__cframe__482.lookVector));
		return;
	end;
	local v483 = u107:Clone();
	v483.Killer.Label.Text = p208;
	v483.Weapon.Label.Text = p210;
	v483.Parent = u113;
	v483.Rank.Label.Text = p211;
	local v484 = u38(p209, p212, p213);
	local v485 = u21(v484.MenuNodes, "ViewportNode") or v484.MenuNodes.MenuNode;
	v484.PrimaryPart = v485;
	v484:SetPrimaryPartCFrame(CFrame.new(0, 0, 0));
	local v486 = u121("Camera");
	v486.CFrame = CFrame.new(v485.CFrame.p + v485.CFrame.RightVector * -7 + v485.CFrame.lookVector * 4 + v485.CFrame.upVector * 4, v485.CFrame.p + v485.CFrame.lookVector * 1.5);
	v486.FieldOfView = 16;
	v486.Parent = v484;
	v484.Parent = v483.WeaponViewport;
	v483.WeaponViewport.CurrentCamera = v486;
	local l__next__487 = next;
	local v488, v489 = v483.Attachments:GetChildren();
	while true do
		local v490, v491 = l__next__487(v488, v489);
		if not v490 then
			break;
		end;
		v489 = v490;
		v491.Type.Text = "None";	
	end;
	if p212 then
		for v492, v493 in next, p212 do
			if v492 ~= "Name" and v493 ~= "" then
				v483.Attachments[v492].Type.Text = u3.getattdisplayname(v493);
			end;
		end;
	end;
	if hud:isplayeralive(p207) then
		camera:setspectate(p207);
	else
		camera:setfixedcam(CFrame.new(l__cframe__482.p, l__cframe__482.p + l__cframe__482.lookVector));
	end;
	task.delay(5, function()
		v484:Destroy();
	end);
end;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u122 = "unlockedattach";
u104 = u103;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u122 = "rankup";
u104 = function(p214, p215, p216)
	local v494 = u10:Clone();
	local l__Money__495 = v494.Money;
	local l__Rank__496 = v494.Rank;
	local v497 = 0;
	local v498 = u113:GetChildren();
	for v499 = 1, #v498 do
		if v498[v499].Name == "RankBar" or v498[v499].Name == "AttachBar" then
			v497 = v497 + 1;
		end;
	end;
	v494.Parent = u113;
	l__Rank__496.Text = p215;
	l__Money__495.Text = "+" .. 5 * (p215 - p214) * (81 + p215 + p214) / 2 .. " CR";
	local u127 = tick();
	local l__Title__128 = v494.Title;
	local u129 = nil;
	u129 = game:GetService("RunService").RenderStepped:connect(function()
		local v500 = tick() - u127;
		if v500 < 3 then
			local v501 = 0;
		else
			v501 = v500 < 3.5 and (v500 - 3) / 0.5 or 1;
		end;
		l__Rank__496.TextTransparency = v501;
		if v500 < 3 then
			local v502 = 0;
		else
			v502 = v500 < 3.5 and (v500 - 3) / 0.5 or 1;
		end;
		l__Title__128.TextTransparency = v502;
		if v500 < 0.5 then
			local v503 = 1;
		elseif v500 < 3.5 then
			v503 = 0;
		else
			v503 = v500 < 4 and (v500 - 3.5) / 0.5 or 1;
		end;
		l__Money__495.TextTransparency = v503;
		if v500 > 4 then
			u129:disconnect();
			v494:Destroy();
			task.spawn(function()
				if p216 then
					for v504 = 1, #p216 do
						u69(p216[v504]);
						task.wait(3);
					end;
				end;
			end);
		end;
	end);
end;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u122 = "bigaward";
u104 = function(p217, p218, p219, p220)
	u62(p217, p218, p219, p220);
end;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u122 = "smallaward";
u104 = function(p221, p222)
	u59(p221, p222);
end;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u122 = "newevent";
u104 = u12;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u122 = "newroundid";
u104 = function(p223)
	v7.updateversionstr(p223);
end;
u54 = network;
u71 = network.add;
u71(u54, u122, u104);
u71 = function()
	local v505 = nil;
	local v506 = nil;
	if not char.alive then
		v505 = u21(u113, "KillBar");
		if v505 then
			v506 = u21(game:GetService("Players"), v505.Killer.Label.Text);
			if not v506 then
				v505.Health.Label.Text = 100;
				v505.Health.Label.TextColor3 = u63(0, 1, 0);
				return;
			end;
		else
			return;
		end;
	else
		return;
	end;
	local v507 = hud:getplayerhealth(v506);
	v505.Health.Label.Text = math.ceil(v507);
	v505.Health.Label.TextColor3 = v507 < 20 and u63(1, 0, 0) or (v507 < 50 and u63(1, 1, 0) or u63(0, 1, 0));
end;
u106.step = u71;
u9 = print;
u11 = "Loading leaderboard module";
u9(u11);
u9 = game;
u21 = "Players";
u11 = u9;
u9 = u9.GetService;
u9 = u9(u11, u21);
u11 = u9.LocalPlayer;
u63 = game;
u61 = u63.ReplicatedStorage;
u13 = u61.Character;
u21 = u13.PlayerTag;
u13 = u11.PlayerGui;
u61 = game;
u64 = "ReplicatedStorage";
u63 = u61;
u61 = u61.GetService;
u61 = u61(u63, u64);
u64 = "Misc";
u63 = u61;
u61 = u61.WaitForChild;
u61 = u61(u63, u64);
u64 = "Player";
u63 = u61;
u61 = u61.WaitForChild;
u61 = u61(u63, u64);
u45 = "Leaderboard";
u64 = u13;
u63 = u13.WaitForChild;
u63 = u63(u64, u45);
u45 = u63;
u64 = u63.WaitForChild;
u64 = u64(u45, "Main");
u121 = "TopBar";
u45 = u64.WaitForChild;
u45 = u45(u64, u121);
u41 = "Ping";
u121 = u45;
local v508 = u45.WaitForChild(u121, u41);
u15 = "Ghosts";
u41 = u64;
u121 = u64.WaitForChild;
u121 = u121(u41, u15);
u16 = "Phantoms";
u15 = u64;
u41 = u64.WaitForChild;
u41 = u41(u15, u16);
u120 = "DataFrame";
u16 = u121;
u15 = u121.WaitForChild;
u15 = u15(u16, u120);
u120 = u41;
u16 = u41.WaitForChild;
u16 = u16(u120, "DataFrame");
u120 = u15.WaitForChild;
u120 = u120(u15, "Data");
local u130 = u16:WaitForChild("Data");
local u131 = function()
	local v509 = game:GetService("Players"):GetPlayers();
	for v510 = 1, #v509 do
		local v511 = v509[v510];
		local v512 = v511.TeamColor == game.Teams.Ghosts.TeamColor and u120 or u130;
		local v513 = (v511.TeamColor ~= game.Teams.Ghosts.TeamColor and u120 or u130):FindFirstChild(v511.Name);
		if not v512:FindFirstChild(v511.Name) and v513 then
			v513.Parent = v512;
		end;
	end;
	local v514 = u120:GetChildren();
	table.sort(v514, function(p224, p225)
		return tonumber(p225.Score.Text) < tonumber(p224.Score.Text);
	end);
	for v515 = 1, #v514 do
		local v516 = v514[v515];
		v516.Position = UDim2.new(0, 0, 0, v515 * 25);
		if v516.Name == u11.Name then
			v516.Username.TextColor3 = Color3.new(1, 1, 0);
		end;
	end;
	u120.Parent.CanvasSize = UDim2.new(0, 0, 0, (#v514 + 1) * 25);
	local v517 = u130:GetChildren();
	table.sort(v517, function(p226, p227)
		return tonumber(p227.Score.Text) < tonumber(p226.Score.Text);
	end);
	for v518 = 1, #v517 do
		local v519 = v517[v518];
		v519.Position = UDim2.new(0, 0, 0, v518 * 25);
		if v519.Name == u11.Name then
			v519.Username.TextColor3 = Color3.new(1, 1, 0);
		end;
	end;
	u130.Parent.CanvasSize = UDim2.new(0, 0, 0, (#v517 + 1) * 25);
end;
local function v520(p228)
	if u120:FindFirstChild(p228.Name) or u130:FindFirstChild(p228.Name) then
		return;
	end;
	local v521 = u61:Clone();
	v521.Name = p228.Name;
	v521.Username.Text = p228.Name;
	v521.Kills.Text = 0;
	v521.Deaths.Text = 0;
	v521.Streak.Text = 0;
	v521.Score.Text = 0;
	v521.Kdr.Text = 0;
	v521.Rank.Text = 0;
	if p228 == u11 then
		v521.Username.TextColor3 = Color3.new(1, 1, 0);
	end;
	v521.Parent = p228.TeamColor == game.Teams.Ghosts.TeamColor and u120 or u130;
	u131();
end;
function v9.show(p229)
	u64.Visible = true;
end;
function v9.hide(p230)
	u64.Visible = false;
end;
local u132 = function(p231, p232)
	local v522 = p231.TeamColor == game.Teams.Ghosts.TeamColor and u120 or u130;
	local v523 = v522:FindFirstChild(p231.Name);
	if not v523 then
		u131();
		v523 = v522:FindFirstChild(p231.Name);
	end;
	if v523 then
		for v524, v525 in next, p232 do
			v523[v524].Text = v525;
		end;
	end;
	u131();
end;
network:add("updatestats", u132);
network:add("fillboard", function(p233)
	for v526, v527 in next, p233 do
		u132(v527.player, v527.stats);
	end;
	u131();
end);
u9.PlayerAdded:connect(v520);
u9.PlayerRemoving:connect(function(p234)
	local v528 = u120:FindFirstChild(p234.Name);
	local v529 = u130:FindFirstChild(p234.Name);
	if v528 then
		v528:Destroy();
	end;
	if v529 then
		v529:Destroy();
	end;
	u131();
end);
local l__next__530 = next;
local v531, v532 = u9:GetPlayers();
while true do
	local v533, v534 = l__next__530(v531, v532);
	if not v533 then
		break;
	end;
	v532 = v533;
	v520(v534);
end;
game:GetService("UserInputService").InputBegan:connect(function(p235)
	local l__KeyCode__535 = p235.KeyCode;
	if l__KeyCode__535 == Enum.KeyCode.Tab and not input.iskeydown(Enum.KeyCode.LeftAlt) or l__KeyCode__535 == Enum.KeyCode.ButtonSelect then
		if u64.Visible then
			v9:hide();
			return;
		end;
		u131();
		v9:show();
	end;
end);
local u133 = 60;
local u134 = v508;
local u135 = tick();
function v9.step(p236)
	u133 = 0.95 * u133 + 0.05 / p236;
	if u64.Visible and u134 and u135 < tick() then
		local v536 = u133 - u133 % 1;
		if v536 ~= v536 or v536 == (1 / 0) or v536 == (-1 / 0) then
			v536 = 60;
			u133 = v536;
		end;
		u134.Text = "Server Avg Send Ping: " .. (network.serverping and 0) .. "ms\nYour Send Ping: " .. (network.playerping and 0) .. "ms\nAverage FPS: " .. v536;
		u135 = tick() + 1;
	end;
end;
u9 = print;
u11 = "Loading char module";
u9(u11);
u11 = shared;
u9 = u11.require;
u11 = "WepScript";
u9 = u9(u11);
u11 = math.pi;
u21 = u11 * 2;
u13 = math.sin;
u61 = math.cos;
u64 = game;
u63 = u64.IsA;
u64 = Instance.new;
u134 = game;
u45 = u134.WaitForChild;
u121 = game;
u134 = u121.FindFirstChild;
u41 = game;
u121 = u41.GetChildren;
u41 = CFrame.new;
u15 = u41;
u15 = u15();
u16 = u15.vectorToWorldSpace;
u120 = CFrame.Angles;
u130 = Vector3.new;
u131 = u130;
u131 = u131();
u132 = game;
u132 = u131.Dot;
local l__LocalPlayer__537 = game:GetService("Players").LocalPlayer;
local l__ReplicatedStorage__538 = game.ReplicatedStorage;
local l__materialhitsound__539 = sound.materialhitsound;
local v540 = { Enum.HumanoidStateType.Dead, Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.Swimming, Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.RunningNoPhysics, Enum.HumanoidStateType.StrafingNoPhysics };
local v541 = spring.new();
local v542 = spring.new();
local v543 = u64("Humanoid");
for v544 = 1, #v540 do
	v543:SetStateEnabled(v540[v544], false);
end;
v543.AutomaticScalingEnabled = false;
v543.AutoRotate = false;
v543.AutoJumpEnabled = false;
v543.BreakJointsOnDeath = false;
v543.HealthDisplayDistance = 0;
v543.NameDisplayDistance = 0;
v543.RequiresNeck = false;
v543.RigType = Enum.HumanoidRigType.R6;
local v545 = spring.new();
local v546 = spring.new(1);
v546.s = 12;
v546.d = 0.95;
char.unaimedfov = 80;
char.speed = 0;
char.distance = 0;
char.sprint = false;
function char.setunaimedfov(p237)
	char.unaimedfov = p237;
end;
local u136 = 0;
local u137 = {};
function char.unloadguns()
	u136 = 0;
	u137 = {};
end;
local v547 = spring.new(u131);
local v548 = spring.new();
local v549 = spring.new(u131);
local v550 = spring.new(0);
local v551 = spring.new(0);
local v552 = spring.new(0);
local v553 = spring.new(0);
local v554 = spring.new(1);
v541.s = 12;
v541.d = 0.9;
v542.s = 12;
v542.d = 0.9;
v545.d = 0.9;
v547.s = 10;
v547.d = 0.75;
v548.s = 16;
v549.s = 16;
v550.s = 8;
v551.s = 8;
v552.s = 20;
v553.s = 8;
v554.s = 12;
v554.d = 0.75;
char.crouchspring = v551;
char.pronespring = v550;
char.slidespring = v552;
local v555 = u64("BodyVelocity");
v555.Name = "\n";
local v556 = spring.new(14);
v556.s = 8;
local v557 = spring.new(1.5);
v557.s = 8;
char.acceleration = u131;
v555.MaxForce = u131;
local u138 = 14;
function char.getslidecondition()
	return u138 * 1.2 < v556.p;
end;
local u139 = false;
local u140 = 1;
local u141 = "stand";
local u142 = 0;
local u143 = nil;
local u144 = false;
local function v558(p238, p239, p240)
	local v559 = nil;
	v559 = char.movementmode;
	char.movementmode = p239;
	u141 = p239;
	if p239 == "prone" then
		if not p240 and v559 ~= p239 then
			sound.play("stanceProne", 0.15);
		end;
		v557.t = -1.5;
		v550.t = 1;
		v551.t = 0;
		v556.t = u140 * u138 / 4;
		hud:setcrossscale(0.5);
		u142 = 0.25;
		if p240 and u139 and u143.Velocity.y > -5 then
			coroutine.wrap(function()
				local l__lookVector__560 = u143.CFrame.lookVector;
				u143.Velocity = l__lookVector__560 * 50 + Vector3.new(0, 40, 0);
				task.wait(0.1);
				u143.Velocity = l__lookVector__560 * 60 + Vector3.new(0, 30, 0);
				task.wait(0.4);
				u143.Velocity = l__lookVector__560 * 20 + Vector3.new(0, -10, 0);
			end)();
		end;
	elseif p239 == "crouch" then
		if not p240 and v559 ~= p239 then
			sound.play("stanceStandCrouch", 0.15);
		end;
		local v561 = char.getslidecondition();
		v557.t = 0;
		v550.t = 0;
		v551.t = 1;
		v556.t = u140 * u138 / 2;
		hud:setcrossscale(0.75);
		u142 = 0.15;
		if p240 and v561 and v543:GetState() ~= Enum.HumanoidStateType.Freefall then
			u144 = true;
			sound.play("slideStart", 0.25);
			char.slidespring.t = 1;
			local u145 = false;
			coroutine.wrap(function()
				local l__rootpart__562 = char.rootpart;
				local v563 = l__rootpart__562.Velocity.unit;
				local v564 = l__rootpart__562.CFrame:VectorToObjectSpace(v563);
				v555.MaxForce = Vector3.new(40000, 10, 40000);
				local v565 = tick();
				while tick() < v565 + 0.6666666666666666 do
					if input.keyboard.down.leftshift or input.controller.down.l3 then
						if u145 then
							break;
						end;
						v563 = camera.cframe:VectorToWorldSpace(v564);
					else
						u145 = true;
					end;
					v555.Velocity = v563 * (40 - (tick() - v565) * 30 / 0.6666666666666666);
					task.wait();				
				end;
				v556.p = l__rootpart__562.Velocity.Magnitude;
				v555.MaxForce = u131;
				v555.Velocity = u131;
				if u144 then
					u144 = false;
					sound.play("slideEnd", 0.15);
				end;
				char.slidespring.t = 0;
			end)();
		end;
	elseif p239 == "stand" then
		if v559 ~= p239 then
			sound.play("stanceStandCrouch", 0.15);
		end;
		v557.t = 1.5;
		v550.t = 0;
		v551.t = 0;
		v556.t = u140 * u138;
		hud:setcrossscale(1);
		u142 = 0;
	end;
	network:send("stance", p239);
	u139 = false;
	network:send("sprint", u139);
	v541.t = 0;
end;
function char.getstate()
	return v543:GetState();
end;
function char.sprinting()
	return u139;
end;
char.setmovementmode = v558;
local function u146()
	if u139 then
		v556.t = 1.4 * u140 * u138;
		return;
	end;
	if u141 == "prone" then
		v556.t = u140 * u138 / 4;
		return;
	end;
	if u141 == "crouch" then
		v556.t = u140 * u138 / 2;
		return;
	end;
	if u141 == "stand" then
		v556.t = u140 * u138;
	end;
end;
function char.setbasewalkspeed(p241, p242)
	u138 = p242;
	u146();
end;
local u147 = false;
local u148 = false;
function char.setsprint(p243, p244)
	local l__currentgun__566 = u53.currentgun;
	if not p244 then
		if u139 then
			u139 = false;
			network:send("sprint", u139);
			v541.t = 0;
			v556.t = u140 * u138;
			if (input.mouse.down.right or input.controller.down.l2) and l__currentgun__566 and l__currentgun__566.type ~= "KNIFE" and l__currentgun__566.type ~= "Grenade" then
				l__currentgun__566:setaim(true);
			end;
		end;
		return;
	end;
	if u144 then
		u144 = false;
		sound.play("slideEnd", 0.15);
	end;
	v558(nil, "stand");
	u139 = true;
	network:send("sprint", u139);
	if l__currentgun__566 then
		l__currentgun__566.auto = false;
		if l__currentgun__566 and l__currentgun__566.isaiming() and l__currentgun__566.type ~= "KNIFE" then
			l__currentgun__566:setaim(false);
		end;
	end;
	u140 = 1;
	if not u147 and not u148 then
		v541.t = 1;
	end;
	v556.t = 1.5 * u140 * u138;
end;
local u149 = nil;
local u150 = u132.Debris;
local u151 = {
	mid = {
		lower = 1.8, 
		upper = 4, 
		width = 1.5, 
		xrays = 5, 
		yrays = 8, 
		dist = 10, 
		sprintdist = 12, 
		color = BrickColor.new("Bright blue")
	}, 
	upper = {
		lower = 5, 
		upper = 6, 
		width = 1, 
		xrays = 5, 
		yrays = 7, 
		dist = 12, 
		sprintdist = 14, 
		color = BrickColor.new("Bright green")
	}
};
local u152 = Ray.new;
local l__Enum_Material_Air__153 = Enum.Material.Air;
local function u154()
	local v567 = u143.CFrame * u41(0, -3, 0);
	local v568 = false;
	local v569 = false;
	local l__lookVector__570 = u143.CFrame.lookVector;
	local v571 = {
		mid = {}, 
		upper = {}
	};
	local v572 = {};
	local l__next__573 = next;
	local v574 = nil;
	while true do
		local v575, v576 = l__next__573(u151, v574);
		if not v575 then
			break;
		end;
		for v577 = 0, v576.xrays - 1 do
			for v578 = 0, v576.yrays - 1 do
				local v579 = (v577 / (v576.xrays - 1) - 0.5) * v576.width;
				local v580 = v567 * Vector3.new(v579, v578 / (v576.yrays - 1) * (v576.upper - v576.lower) + v576.lower, 0);
				local v581, v582 = workspace:FindPartOnRayWithWhitelist(u152(v580, l__lookVector__570 * (u139 and v576.sprintdist or v576.dist)), roundsystem.raycastwhitelist);
				if v581 and v581.CanCollide then
					local l__Magnitude__583 = (v580 - v582).Magnitude;
					v571[v575][#v571[v575] + 1] = l__Magnitude__583;
					if v575 == "mid" then
						v568 = true;
						if v579 == 0 then
							v572[#v572 + 1] = l__Magnitude__583;
						end;
					elseif v575 == "upper" then
						v569 = true;
					end;
				end;
			end;
		end;	
	end;
	if v568 then
		local v584 = {};
		for v585 = 2, #v572 do
			v584[#v584 + 1] = v572[v585] - v572[v585 - 1];
		end;
		local v586 = nil;
		for v587 = 1, #v584 do
			if 0 == 0 then
				v586 = v584[v587];
				local v588 = 1;
			elseif math.abs(v584[v587] - v586) < 0.01 then
				v588 = 0 + 1;
			else
				v588 = 0 - 1;
			end;
		end;
		local v589 = 0;
		for v590 = 1, #v584 do
			if math.abs(v584[v590] - v586) < 0.01 then
				v589 = v589 + 1;
			end;
		end;
		if #v584 / 2 < v589 and v586 ~= 0 and math.abs((u151.mid.upper - u151.mid.lower) / u151.mid.yrays / v586) < 2 then
			return false;
		end;
		local v591 = {
			mid = 100, 
			upper = 100
		};
		local v592 = {
			mid = 0, 
			upper = 0
		};
		local l__next__593 = next;
		local v594 = nil;
		while true do
			local v595, v596 = l__next__593(v571, v594);
			if not v595 then
				break;
			end;
			for v597 = 1, #v596 do
				local v598 = v596[v597];
				if v598 < v591[v595] then
					v591[v595] = v598;
				end;
				if v592[v595] < v598 then
					v592[v595] = v598;
				end;
			end;		
		end;
		if not v569 or v569 and math.abs((v592.upper + v591.upper - v592.mid - v591.mid) / 2) > 4 then
			return true;
		end;
	end;
end;
local function u155()
	if u149 and not u147 and not char.grenadehold then
		u149:playanimation("parkour");
	end;
	sound.play("parkour", 0.25);
	v555.MaxForce = u131;
	local v599 = u64("BodyPosition");
	v599.Name = "\n";
	v599.position = u143.Position + u143.CFrame.lookVector.unit * char.speed * 1.5 + Vector3.new(0, 10, 0);
	v599.maxForce = Vector3.new(500000, 500000, 500000);
	v599.P = 4000;
	v599.Parent = u143;
	u150:AddItem(v599, 0.5);
end;
function char.jump(p245, p246)
	if char.FloorMaterial == l__Enum_Material_Air__153 then
		return;
	end;
	if u53.currentgun.knife then
		p246 = p246 * 1.15;
	end;
	local l__CFrame__600 = u143.CFrame;
	local l__y__601 = u143.Velocity.y;
	local v602 = p246 and (2 * game.Workspace.Gravity * p246) ^ 0.5 or 40;
	if l__y__601 < 0 then
		local v603 = v602;
	else
		v603 = (l__y__601 * l__y__601 + v602 * v602) ^ 0.5;
	end;
	if u141 == "prone" or u141 == "crouch" then
		v558(nil, "stand");
		return;
	end;
	if not u149 or not (not u149.isaiming()) then
		v543.JumpPower = v603;
		v543.Jump = true;
		return true;
	end;
	if char.speed > 5 and u154() then
		u155();
	else
		v543.JumpPower = v603;
		v543.Jump = true;
	end;
	return true;
end;
char.grenadehold = false;
local l__AttachmentModels__156 = l__ReplicatedStorage__538.AttachmentModels;
local u157 = u41().toObjectSpace;
local function u158(p247, p248)
	if p247 then
		local l__BrickColor_new__604 = BrickColor.new;
		local l__next__605 = next;
		local v606, v607 = p248:GetChildren();
		while true do
			local v608, v609 = l__next__605(v606, v607);
			if not v608 then
				break;
			end;
			v607 = v608;
			if not (not u134(v609, "Mesh")) or not (not v609:IsA("UnionOperation")) or v609:IsA("MeshPart") then
				local v610 = u134(v609, "Slot1") or u134(v609, "Slot2");
				if v610 and v610.Name then
					local l__next__611 = next;
					local v612, v613 = v609:GetChildren();
					while true do
						local v614, v615 = l__next__611(v612, v613);
						if not v614 then
							break;
						end;
						v613 = v614;
						if v615:IsA("Texture") then
							v615:Destroy();
						end;					
					end;
					local v616 = p247[v610.Name];
					if v616 and v616.Name ~= "" then
						if not effects.disable1pcamoskins then
							local v617 = Instance.new("Texture");
							v617.Name = v610.Name;
							v617.Texture = "rbxassetid://" .. v616.TextureProperties.TextureId;
							if v609.Transparency == 1 then
								local v618 = 1;
							else
								v618 = v616.TextureProperties.Transparency or 0;
							end;
							v617.Transparency = v618;
							v617.StudsPerTileU = v616.TextureProperties.StudsPerTileU and 1;
							v617.StudsPerTileV = v616.TextureProperties.StudsPerTileV and 1;
							v617.OffsetStudsU = v616.TextureProperties.OffsetStudsU and 0;
							v617.OffsetStudsV = v616.TextureProperties.OffsetStudsV and 0;
							if v616.TextureProperties.Color then
								local l__Color__619 = v616.TextureProperties.Color;
								v617.Color3 = Color3.new(l__Color__619.r / 255, l__Color__619.g / 255, l__Color__619.b / 255);
							end;
							if v609:IsA("MeshPart") or v609:IsA("UnionOperation") then
								local v620 = 5;
							else
								v620 = 0;
							end;
							for v621 = 0, v620 do
								local v622 = v617:Clone();
								v622.Face = v621;
								v622.Parent = v609;
							end;
							v617:Destroy();
						end;
						if not v616.BrickProperties.DefaultColor then
							if v609:IsA("UnionOperation") then
								v609.UsePartColor = true;
							end;
							local l__Color__623 = v616.BrickProperties.Color;
							if l__Color__623 then
								v609.Color = Color3.new(l__Color__623.r / 255, l__Color__623.g / 255, l__Color__623.b / 255);
							elseif v616.BrickProperties.BrickColor then
								v609.BrickColor = l__BrickColor_new__604(v616.BrickProperties.BrickColor);
							end;
						end;
						if v616.BrickProperties.Material then
							v609.Material = v616.BrickProperties.Material;
						end;
						if v616.BrickProperties.Reflectance then
							v609.Reflectance = v616.BrickProperties.Reflectance;
						end;
					end;
				end;
			elseif v609:IsA("Model") then
				u158(p247, v609);
			end;		
		end;
	end;
end;
local function u159(p249, p250, p251, p252, p253, p254, p255, p256, p257)
	local v624 = p254.altmodel and u134(l__AttachmentModels__156, p254.altmodel) or u134(l__AttachmentModels__156, p251);
	local v625 = nil;
	if v624 then
		for v626 = 0, p254.copy and 0 do
			local v627 = v624:Clone();
			local l__Node__628 = v627.Node;
			local v629 = {};
			local l__CFrame__630 = l__Node__628.CFrame;
			local v631 = u121(v627);
			for v632 = 1, #v631 do
				local v633 = v631[v632];
				if v633:IsA("BasePart") then
					v629[v633] = u157(l__CFrame__630, v633.CFrame);
					v633.CastShadow = false;
					v633.Massless = true;
				end;
			end;
			l__Node__628.CFrame = v626 == 0 and p252.CFrame or p257[p254.copynodes[v626]].CFrame;
			if p250 == "Optics" then
				local v634 = p249:GetChildren();
				for v635 = 1, #v634 do
					if v634[v635].Name == "Iron" or v634[v635].Name == "IronGlow" or v634[v635].Name == "SightMark" and not u134(v634[v635], "Stay") then
						v634[v635]:Destroy();
					end;
				end;
			elseif p250 == "Underbarrel" then
				local v636 = p249:GetChildren();
				for v637 = 1, #v636 do
					if v636[v637].Name == "Grip" then
						v625 = u134(v636[v637], "Slot1") or u134(v636[v637], "Slot2");
						v636[v637]:Destroy();
					end;
				end;
			elseif p250 == "Barrel" then
				local v638 = p249:GetChildren();
				for v639 = 1, #v638 do
					if v638[v639].Name == "Barrel" then
						v625 = u134(v638[v639], "Slot1") or u134(v638[v639], "Slot2");
						v638[v639]:Destroy();
					end;
				end;
			end;
			if p254.replacemag then
				local v640 = p249:GetChildren();
				for v641 = 1, #v640 do
					if v626 == 0 and v640[v641].Name == "Mag" or v626 > 0 and v640[v641].Name == "Mag" .. v626 + 1 then
						v640[v641]:Destroy();
					end;
				end;
			end;
			if p254.replacepart then
				local v642 = p249:GetChildren();
				for v643 = 1, #v642 do
					if v642[v643].Name == p254.replacepart then
						v642[v643]:Destroy();
					end;
				end;
			end;
			if p255 and p255[p251] and p255[p251].settings then
				for v644, v645 in next, p255[p251].settings do
					if v644 == "sightcolor" then
						local v646 = u134(v627, "SightMark");
						if v646 and u134(v646, "SurfaceGui") then
							local l__SurfaceGui__647 = v646.SurfaceGui;
							if u134(l__SurfaceGui__647, "Border") and u134(l__SurfaceGui__647.Border, "Scope") then
								l__SurfaceGui__647.Border.Scope.ImageColor3 = Color3.new(v645.r / 255, v645.g / 255, v645.b / 255);
							end;
						end;
					end;
				end;
			end;
			for v648 = 1, #v631 do
				local v649 = v631[v648];
				if v649:IsA("BasePart") then
					local v650 = nil;
					local v651 = nil;
					if v649 ~= l__Node__628 then
						v651 = u157(p253.CFrame, l__Node__628.CFrame);
						v650 = u64("Weld");
						v650.Part0 = p253;
						v650.Part1 = v649;
						v650.C0 = v651 * v629[v649];
						v650.Parent = p253;
						v649.CFrame = p253.CFrame * v650.C0;
					end;
					if v625 and v649:IsA("UnionOperation") then
						v625:Clone().Parent = v649;
					end;
					if p254.replacemag and v649.Name == "AttMag" then
						if v626 == 0 then
							local v652 = "Mag";
						else
							v652 = false;
							if v626 > 0 then
								v652 = "Mag" .. v626 + 1;
							end;
						end;
						v649.Name = v652;
					end;
					if p254.replacepart and v649.Name == "Part" then
						v649.Name = p254.replacepart;
					end;
					if v649 ~= l__Node__628 then
						p256[v649.Name] = {
							part = v649, 
							weld = v650, 
							basec0 = v651 * v629[v649], 
							basetransparency = v649.Transparency
						};
					end;
					v649.Anchored = false;
					v649.CanCollide = false;
					v649.Parent = p249;
				end;
			end;
			l__Node__628:Destroy();
			v627:Destroy();
		end;
	end;
	return v625;
end;
local l__Clone__653 = game.Clone;
local l__FindFirstChild__654 = game.FindFirstChild;
local u160 = nil;
local u161 = nil;
local l__CurrentCamera__162 = game.Workspace.CurrentCamera;
local u163 = nil;
local u164 = nil;
local u165 = nil;
local u166 = nil;
local function u167(p258, p259, p260, p261, p262, p263, p264)
	local v655 = {};
	local v656 = p258:GetChildren();
	local l__CFrame__657 = p259.CFrame;
	local v658 = u134(p258, "MenuNodes");
	if not p264 then
		for v659 = 1, #v656 do
			local v660 = v656[v659];
			if v660:IsA("BasePart") then
				v660.Massless = true;
				v660.CastShadow = false;
			end;
			if v660 ~= p259 and v660:IsA("BasePart") then
				local l__Name__661 = v660.Name;
				if p261 and p261.removeparts and p261.removeparts[l__Name__661] then
					v660:Destroy();
				else
					if p261 and p261.transparencymod and p261.transparencymod[l__Name__661] then
						v660.Transparency = p261.transparencymod[l__Name__661];
					end;
					if p261 and p261.weldexception and p261.weldexception[l__Name__661] and u134(p258, p261.weldexception[l__Name__661]) then
						local v662 = p258[p261.weldexception[l__Name__661]];
						local v663 = u157(v662.CFrame, v660.CFrame);
						local v664 = u64("Weld");
						v664.Part0 = v662;
						v664.Part1 = v660;
						v664.C0 = v663;
						v664.Parent = p259;
						v660.CFrame = l__CFrame__657 * v663;
						v655[l__Name__661] = {
							part = v660, 
							weld = v664, 
							basec0 = v663, 
							basetransparency = v660.Transparency
						};
					else
						local v665 = u157(l__CFrame__657, v660.CFrame);
						local v666 = u64("Weld");
						v666.Part0 = p259;
						v666.Part1 = v660;
						v666.C0 = v665;
						v666.Parent = p259;
						v660.CFrame = l__CFrame__657 * v665;
						v655[l__Name__661] = {
							part = v660, 
							weld = v666, 
							basec0 = v665, 
							basetransparency = v660.Transparency
						};
					end;
					v660.Anchored = false;
					v660.CanCollide = false;
				end;
			end;
		end;
	end;
	if v658 and p260 then
		local v667 = v658:GetChildren();
		for v668 = 1, #v667 do
			local v669 = v667[v668];
			local v670 = u64("Weld");
			v670.Part0 = p259;
			v670.Part1 = v669;
			v670.C0 = u157(l__CFrame__657, v669.CFrame);
			v670.Parent = p259;
			v669.Massless = true;
			v669.CastShadow = false;
			v669.Anchored = false;
			v669.CanCollide = false;
		end;
		for v671, v672 in next, p260 do
			if v671 ~= "Name" and v672 and v672 ~= "" then
				local v673 = p261.attachments and p261.attachments[v671][v672] or {};
				local v674 = v673.sidemount and l__AttachmentModels__156[v673.sidemount]:Clone();
				local v675 = v673.mountweldpart and p258[v673.mountweldpart] or p259;
				local v676 = v673.node and v658[v673.node];
				local v677 = {};
				if v674 then
					local l__Node__678 = v674.Node;
					if v673.mountnode then
						local v679 = v658[v673.mountnode];
						if not v679 then
							if v671 == "Optics" then
								v679 = v658.MountNode;
								if not v679 then
									v679 = false;
									if v671 == "Underbarrel" then
										v679 = v658.UnderMountNode;
									end;
								end;
							else
								v679 = false;
								if v671 == "Underbarrel" then
									v679 = v658.UnderMountNode;
								end;
							end;
						end;
					elseif v671 == "Optics" then
						v679 = v658.MountNode;
						if not v679 then
							v679 = false;
							if v671 == "Underbarrel" then
								v679 = v658.UnderMountNode;
							end;
						end;
					else
						v679 = false;
						if v671 == "Underbarrel" then
							v679 = v658.UnderMountNode;
						end;
					end;
					local v680 = {};
					local v681 = v674:GetChildren();
					local l__CFrame__682 = l__Node__678.CFrame;
					for v683 = 1, #v681 do
						if v681[v683]:IsA("BasePart") then
							v680[v683] = u157(l__CFrame__682, v681[v683].CFrame);
						end;
					end;
					l__Node__678.CFrame = v679.CFrame;
					for v684 = 1, #v681 do
						local v685 = v681[v684];
						if v685:IsA("BasePart") then
							local v686 = u157(v675.CFrame, l__Node__678.CFrame);
							local v687 = u157(p259.CFrame, v675.CFrame);
							if v685 ~= l__Node__678 then
								local v688 = u64("Weld");
								if v673.weldtobase then
									v688.Part0 = p259;
									v688.Part1 = v685;
									v688.C0 = v687 * v686 * v680[v684];
									v685.CFrame = l__Node__678.CFrame * v680[v684];
									local v689 = u157(l__CFrame__657, v685.CFrame);
								else
									v688.Part0 = v675;
									v688.Part1 = v685;
									v688.C0 = v686 * v680[v684];
									v685.CFrame = l__Node__678.CFrame * v680[v684];
									v689 = u157(v675.CFrame, v685.CFrame);
								end;
								v688.Parent = p259;
								v655[v685.Name] = {
									part = v685, 
									weld = v688, 
									basec0 = v689, 
									basetransparency = v685.Transparency
								};
							end;
							v685.CastShadow = false;
							v685.Massless = true;
							v685.Anchored = false;
							v685.CanCollide = false;
							v685.Parent = p258;
							v677[v685.Name] = v685;
							if v685.Name == v671 .. "Node" and not v676 then
								v676 = v685;
							elseif v685.Name == "SightMark" then
								local v690 = u64("Model");
								v690.Name = "Stay";
								v690.Parent = v685;
							end;
						end;
					end;
					l__Node__678.Parent = v658;
					v674:Destroy();
				else
					local v691 = v673.node and v658[v673.node] or v658[v671 .. "Node"];
				end;
				if v673.auxmodels then
					local v692 = {};
					local l__next__693 = next;
					local l__auxmodels__694 = v673.auxmodels;
					local v695 = nil;
					while true do
						local v696, v697 = l__next__693(l__auxmodels__694, v695);
						if not v696 then
							break;
						end;
						local v698 = v697.Name or v672 .. " " .. v697.PostName;
						local v699 = l__AttachmentModels__156[v698]:Clone();
						local l__Node__700 = v699.Node;
						v692[v698] = {};
						if v697.sidemount and v677[v697.Node] then
							local v701 = v677[v697.Node];
						elseif v697.auxmount and v692[v697.auxmount] and v692[v697.auxmount][v697.Node] then
							v701 = v692[v697.auxmount][v697.Node];
						else
							v701 = v658[v697.Node];
						end;
						if v697.mainnode then
							v691 = v699[v697.mainnode];
						end;
						local v702 = {};
						local v703 = v699:GetChildren();
						local l__CFrame__704 = l__Node__700.CFrame;
						for v705 = 1, #v703 do
							if v703[v705]:IsA("BasePart") then
								v702[v705] = u157(l__CFrame__704, v703[v705].CFrame);
							end;
						end;
						l__Node__700.CFrame = v701.CFrame;
						for v706 = 1, #v703 do
							local v707 = v703[v706];
							if v707:IsA("BasePart") then
								local v708 = u157(v675.CFrame, l__Node__700.CFrame);
								local v709 = u157(p259.CFrame, v675.CFrame);
								if v707 ~= l__Node__700 then
									local v710 = u64("Weld");
									if v697.weldtobase then
										v710.Part0 = p259;
										v710.Part1 = v707;
										v710.C0 = v709 * v708 * v702[v706];
										v707.CFrame = l__Node__700.CFrame * v702[v706];
										local v711 = u157(l__CFrame__657, v707.CFrame);
									else
										v710.Part0 = v675;
										v710.Part1 = v707;
										v710.C0 = v708 * v702[v706];
										v707.CFrame = l__Node__700.CFrame * v702[v706];
										v711 = u157(v675.CFrame, v707.CFrame);
									end;
									v710.Parent = p259;
									v655[v707.Name] = {
										part = v707, 
										weld = v710, 
										basec0 = v711, 
										basetransparency = v707.Transparency
									};
								end;
								v707.CastShadow = false;
								v707.Massless = true;
								v707.Anchored = false;
								v707.CanCollide = false;
								v707.Parent = p258;
								v692[v698][v707.Name] = v707;
								if v707.Name == v696 .. "Node" and not v691 then
									v691 = v707;
								elseif v707.Name == "SightMark" then
									local v712 = u64("Model");
									v712.Name = "Stay";
									v712.Parent = v707;
								end;
							end;
						end;
						v699:Destroy();					
					end;
				end;
				u159(p258, v671, v672, v691, v673.weldpart and p258[v673.weldpart] or p259, v673, p263, v655, v658);
			end;
		end;
		v658:Destroy();
	end;
	if not p264 then
		u158(p262, p258);
		v655.camodata = p262;
		p259.Anchored = false;
		p259.CanCollide = false;
	end;
	if p261 then
		local v713 = {};
		v655.gunvars = v713;
		v713.ammotype = p261.casetype or p261.ammotype;
		v713.boltlock = p261.boltlock;
	end;
	return v655;
end;
function char.loadarms(p265, p266, p267, p268, p269)
	if u160 and u161 then
		u160:Destroy();
		u161:Destroy();
	end;
	u160 = p266;
	u161 = p267;
	u160.Parent = l__CurrentCamera__162;
	u161.Parent = l__CurrentCamera__162;
	u163 = u160[p268];
	u164 = u161[p269];
	u165 = u64("Motor6D");
	u166 = u64("Motor6D");
	u167(u160, u163);
	u167(u161, u164);
	u166.Part0 = u143;
	u166.Part1 = u163;
	u166.Parent = u163;
	u165.Part0 = u143;
	u165.Part1 = u164;
	u165.Parent = u164;
end;
local u168 = spring.new(0);
local u169 = nil;
function char.reloadsprings(p270)
	v550.t = 0;
	v551.t = 0;
	v554.t = 1;
	v554.s = 12;
	v554.d = 0.75;
	v541.t = 0;
	v541.s = 12;
	v541.d = 0.9;
	v545.t = 0;
	v545.d = 0.9;
	v547.t = u131;
	v547.s = 10;
	v547.d = 0.75;
	v548.t = 0;
	v548.s = 16;
	v549.t = u131;
	v549.s = 16;
	v553.t = 0;
	v553.s = 8;
	u168.t = 0;
	u168.s = 50;
	u168.d = 1;
	v556.t = u138;
	v556.s = 8;
	v557.t = 1.5;
	v557.s = 8;
	if u169 then
		u169:Destroy();
	end;
	u169 = l__ReplicatedStorage__538.Effects.MuzzleLight:Clone();
	u169.Parent = u143;
end;
local u170 = math.random;
function char.firemuzzlelight(p271)
	u168.a = 100;
end;
local u171 = false;
local u172 = sequencer.new();
local u173 = game.FindFirstChild;
local function u174(p272, p273)
	local v714 = nil;
	local v715 = nil;
	local v716 = p272 and 1;
	local v717 = p273 and 1;
	v714 = char.distance * u21 * 3 / 4;
	v715 = -char.velocity;
	local v718 = char.speed * (1 - char.slidespring.p * 0.9);
	if v718 < u138 then
		return u41(v717 * u61(v714 / 8 - 1) * v718 / 196, 1.25 * v716 * u13(v714 / 4) * v718 / 512, 0) * cframe.fromaxisangle(Vector3.new(v717 * u13(v714 / 4 - 1) / 256 + v717 * (u13(v714 / 64) - v717 * v715.z / 4) / 512, v717 * u61(v714 / 128) / 128 - v717 * u61(v714 / 8) / 256, v717 * u13(v714 / 8) / 128 + v717 * v715.x / 1024) * v718 / 20 * u21);
	end;
	return u41(v717 * u61(v714 / 8 - 1) * (5 * v718 - 56) / 196, 1.25 * v716 * u13(v714 / 4) * v718 / 512, 0) * cframe.fromaxisangle((Vector3.new((v717 * u13(v714 / 4 - 1) / 256 + v717 * (u13(v714 / 64) - v717 * v715.z / 4) / 512) * v718 / 20 * u21, (v717 * u61(v714 / 128) / 128 - v717 * u61(v714 / 8) / 256) * v718 / 20 * u21, v717 * u13(v714 / 8) / 128 * (5 * v718 - 56) / 20 * u21 + v717 * v715.x / 1024)));
end;
local function u175(p274)
	local v719 = os.clock() * 6;
	local v720 = 2 * (1.1 - p274);
	return u41(u61(v719 / 8) * v720 / 128, -u13(v719 / 4) * v720 / 128, u13(v719 / 16) * v720 / 64);
end;
function char.loadgrenade(p275, p276, p277)
	local v721 = {};
	local v722 = u52(p276);
	local v723 = l__getGunModel__125(p276):Clone();
	local l__mainpart__724 = v722.mainpart;
	local v725 = v723[l__mainpart__724];
	local l__blastradius__726 = v722.blastradius;
	local l__range0__727 = v722.range0;
	local l__range1__728 = v722.range1;
	local l__damage0__729 = v722.damage0;
	local l__damage1__730 = v722.damage1;
	local v731 = u167(v723, v725);
	local v732 = u64("Motor6D");
	v731[l__mainpart__724] = {
		weld = {
			C0 = u15
		}, 
		basec0 = u15
	};
	v731.larm = {
		weld = {
			C0 = v722.larmoffset
		}, 
		basec0 = v722.larmoffset
	};
	v731.rarm = {
		weld = {
			C0 = v722.rarmoffset
		}, 
		basec0 = v722.rarmoffset
	};
	v732.Part0 = u143;
	v732.Part1 = v725;
	v732.Parent = v725;
	local l__equipoffset__733 = v722.equipoffset;
	v721.type = v722.type;
	v721.cooking = false;
	function v721.isaiming()
		return false;
	end;
	local u176 = false;
	function v721.setequipped(p278, p279)
		if not p279 or u176 and u171 then
			if not p279 and u176 then
				v554.t = 1;
				u172:clear();
				u172:add(function()
					u176 = false;
					v723.Parent = nil;
					u148 = false;
					u149 = nil;
				end);
				u172:delay(0.5);
			end;
			return;
		end;
		if not char.alive then
			return;
		end;
		char.grenadehold = true;
		hud:setcrosssettings(v722.type, v722.crosssize, v722.crossspeed, v722.crossdamper, l__mainpart__724);
		hud:updatefiremode("KNIFE");
		hud:updateammo("GRENADE");
		u171 = true;
		u172:clear();
		p277:setequipped(false);
		u172:add(function()
			char:setbasewalkspeed(v722.walkspeed);
			v554.t = 0;
			u171 = false;
			u176 = true;
			local v734 = v725:GetChildren();
			for v735 = 1, #v734 do
				if v734[v735]:IsA("Weld") and (not v734[v735].Part1 or v734[v735].Part1.Parent ~= v723) then
					v734[v735]:Destroy();
				end;
			end;
			v723.Parent = l__CurrentCamera__162;
			u149 = p278;
		end);
	end;
	local u177 = nil;
	local u178 = Vector3.new();
	local l__throwspeed__179 = v722.throwspeed;
	local u180 = Vector3.new();
	local u181 = 0;
	local u182 = nil;
	local u183 = nil;
	local u184 = nil;
	local u185 = 0;
	local u186 = Vector3.new(0, -80, 0);
	local u187 = Vector3.new();
	local u188 = false;
	local u189 = 0;
	local u190 = false;
	local u191 = false;
	local u192 = false;
	local u193 = sequencer.new();
	local function u194(p280)
		if not p280 and roundsystem.lock then
			return;
		end;
		if not v725.Parent or u53.gammo <= 0 then
			return;
		end;
		u53.gammo = u53.gammo - 1;
		hud:updateammo("GRENADE");
		local v736 = tick();
		v732:Destroy();
		u177 = u173(v725, "Indicator");
		if u177 then
			u177.Friendly.Visible = true;
		end;
		v725.CastShadow = false;
		v725.Massless = true;
		v725.Anchored = true;
		v725.Trail.Enabled = true;
		v725.Ticking:Play();
		v725.Parent = workspace.Ignore.Misc;
		v723.Parent = nil;
		u178 = char.alive and (camera.cframe * u120(math.rad(v722.throwangle and 0), 0, 0)).lookVector * l__throwspeed__179 + u143.Velocity or Vector3.new(math.random(-3, 5), math.random(0, 2), math.random(-3, 5));
		u180 = char.deadcf and char.deadcf.p or v725.CFrame.p;
		local l__p__737 = camera.basecframe.p;
		local v738, v739, v740 = workspace:FindPartOnRayWithWhitelist(u152(l__p__737, u180 - l__p__737), roundsystem.raycastwhitelist);
		u180 = v739 + 0.01 * v740;
		u181 = v736;
		u182 = (camera.cframe - camera.cframe.p) * Vector3.new(19.539, -5, 0);
		u183 = v725.CFrame - v725.CFrame.p;
		local l__CFrame__741 = v725.CFrame;
		u184 = {
			time = v736, 
			blowuptime = u185 - v736, 
			frames = { {
					t0 = 0, 
					p0 = u180, 
					v0 = u178, 
					offset = u131, 
					a = u186, 
					rot0 = l__CFrame__741 - l__CFrame__741.p, 
					rotv = u182, 
					glassbreaks = {}
				} }
		};
		for v742 = 1, (u185 - v736) / 0.016666666666666666 + 1 do
			local v743 = u180 + 0.016666666666666666 * u178 + 0.0001388888888888889 * u186;
			local v744, v745, v746 = workspace:FindPartOnRayWithWhitelist(u152(u180, v743 - u180 - 0.05 * u187), roundsystem.raycastwhitelist);
			local v747 = 0.016666666666666666 * v742;
			if v744 and v744.Name ~= "Window" and v744.Name ~= "Col" then
				u183 = v725.CFrame - v725.CFrame.p;
				u187 = 0.2 * v746;
				u182 = v746:Cross(u178) / 0.2;
				local v748 = v745 - u180;
				local v749 = 1 - 0.001 / v748.magnitude;
				if v749 < 0 then
					local v750 = 0;
				else
					v750 = v749;
				end;
				u180 = u180 + v750 * v748 + 0.05 * v746;
				local v751 = u132(v746, u178) * v746;
				local v752 = u178 - v751;
				local v753 = -u132(v746, u186);
				local v754 = -1.2 * u132(v746, u178);
				if v753 < 0 then
					local v755 = 0;
				else
					v755 = v753;
				end;
				if v754 < 0 then
					local v756 = 0;
				else
					v756 = v754;
				end;
				local v757 = 1 - 0.08 * (10 * v755 * 0.016666666666666666 + v756) / v752.magnitude;
				if v757 < 0 then
					local v758 = 0;
				else
					v758 = v757;
				end;
				u178 = v758 * v752 - 0.2 * v751;
				if u178.magnitude < 1 then
					local l__frames__759 = u184.frames;
					l__frames__759[#l__frames__759 + 1] = {
						t0 = v747 - 0.016666666666666666 * (v743 - v745).magnitude / (v743 - u180).magnitude, 
						p0 = u180, 
						v0 = u131, 
						a = u131, 
						rot0 = cframe.fromaxisangle(v747 * u182) * u183, 
						offset = 0.2 * v746, 
						rotv = u131, 
						glassbreaks = {}
					};
					break;
				end;
				local l__frames__760 = u184.frames;
				l__frames__760[#l__frames__760 + 1] = {
					t0 = v747 - 0.016666666666666666 * (v743 - v745).magnitude / (v743 - u180).magnitude, 
					p0 = u180, 
					v0 = u178, 
					a = u188 and u131 or u186, 
					rot0 = cframe.fromaxisangle(v747 * u182) * u183, 
					offset = 0.2 * v746, 
					rotv = u182, 
					glassbreaks = {}
				};
				u188 = true;
			else
				u180 = v743;
				u178 = u178 + 0.016666666666666666 * u186;
				u188 = false;
				if v744 and v744.Name == "Window" and u189 < 5 then
					u189 = u189 + 1;
					local l__frames__761 = u184.frames;
					local l__glassbreaks__762 = l__frames__761[#l__frames__761].glassbreaks;
					l__glassbreaks__762[#l__glassbreaks__762 + 1] = {
						t = v747, 
						part = v744
					};
				end;
			end;
		end;
		network:send("newgrenade", v722.name, u184);
	end;
	function v721.throw(p281)
		if roundsystem.lock or u53.gammo <= 0 then
			return;
		end;
		if u190 and not u191 then
			local v763 = tick();
			u191 = true;
			u190 = false;
			p281.cooking = u190;
			u192 = false;
			v541.t = 0;
			u172:add(animation.player(v731, v722.animations.throw));
			u193:delay(0.07);
			u193:add(function()
				u194();
				if u139 then
					v541.t = 1;
				end;
				u191 = false;
			end);
			u172:add(function()
				if p277 then
					p277:setequipped(true);
				end;
			end);
		end;
	end;
	local u195 = v723[v722.pin];
	local u196 = 0;
	local l__fusetime__197 = v722.fusetime;
	function v721.pull(p282)
		local v764 = tick();
		if not u190 and not u191 then
			if u148 then
				u172:add(animation.reset(v731, 0.1));
				u148 = false;
			end;
			u172:add(animation.player(v731, v722.animations.pull));
			u172:add(function()
				hud.crossspring.a = v722.crossexpansion;
				u195:Destroy();
				u190 = true;
				p282.cooking = u190;
				u196 = v764 + l__fusetime__197;
				u185 = v764 + 5;
			end);
		end;
	end;
	local u198 = 1;
	local u199 = tick();
	local u200 = nil;
	u200 = game:GetService("RunService").RenderStepped:connect(function(p283)
		u193.step();
		local v765 = tick();
		if u190 and not u191 then
			if not char.alive then
				u190 = false;
				v721.cooking = u190;
				u191 = true;
				u192 = false;
				u194(true);
				u191 = false;
				v721:setequipped(false);
			elseif u196 < v765 or not input.keyboard.down.g then
				v721:throw();
			elseif (u196 - v765) % 1 < p283 then
				hud.crossspring.a = v722.crossexpansion;
			end;
		end;
		if v725 and u184 then
			local l__time__766 = u184.time;
			local l__frames__767 = u184.frames;
			local v768 = l__frames__767[u198];
			local l__glassbreaks__769 = v768.glassbreaks;
			for v770 = 1, #l__glassbreaks__769 do
				local v771 = l__glassbreaks__769[v770];
				if u199 < l__time__766 + v771.t and l__time__766 + v771.t <= v765 then
					effects:breakwindow(v771.part, nil, nil, Vector3.new());
				end;
			end;
			local v772 = l__frames__767[u198 + 1];
			if v772 and u184.time + v772.t0 < v765 then
				u198 = u198 + 1;
				v768 = v772;
			end;
			local v773 = v765 - (l__time__766 + v768.t0);
			local v774 = v768.p0 + v773 * v768.v0 + v773 * v773 / 2 * v768.a + v768.offset;
			v725.CFrame = cframe.fromaxisangle(v773 * v768.rotv) * v768.rot0 + v774;
			if u177 then
				u177.Enabled = not workspace:FindPartOnRayWithWhitelist(u152(v774, camera.cframe.p - v774), roundsystem.raycastwhitelist);
			end;
			if l__time__766 + u184.blowuptime < v765 then
				u200:Disconnect();
				v725:Destroy();
			end;
		end;
		u199 = v765;
	end);
	local l__mainoffset__201 = v722.mainoffset;
	local u202 = cframe.interpolator(v722.proneoffset);
	local u203 = cframe.interpolator(v722.sprintoffset);
	function v721.step()
		local v775 = u143.CFrame:inverse() * camera.shakecframe * l__mainoffset__201 * v731[l__mainpart__724].weld.C0 * u202(v550.p) * u41(0, 0, 1) * cframe.fromaxisangle(v547.v) * u41(0, 0, -1) * u174(0.7, 1) * u175(0) * cframe.interpolate(u203(v553.p / v556.p * v541.p), v722.equipoffset, v554.p);
		v732.C0 = v775;
		u166.C0 = v775 * v731.larm.weld.C0;
		u165.C0 = v775 * v731.rarm.weld.C0;
	end;
	return v721;
end;
local l__Players__204 = workspace:WaitForChild("Players");
local l__Map__205 = workspace:WaitForChild("Map");
function char.loadknife(p284, p285)
	local v776 = {};
	local v777 = u52(p284);
	local v778 = l__getGunModel__125(p284):Clone();
	v776.knife = true;
	v776.name = v777.name;
	v776.type = v777.type;
	v776.camodata = p285;
	v776.texturedata = {};
	local v779 = sequencer.new();
	local l__mainpart__780 = v777.mainpart;
	local v781 = v778[l__mainpart__780];
	local v782 = nil;
	local l__range0__783 = v777.range0;
	local l__range1__784 = v777.range1;
	local v785 = v781:Clone();
	v785.Name = "Handle";
	v785.Parent = v778;
	local v786 = {};
	local l__CFrame__787 = v785.CFrame;
	local v788 = v778:GetChildren();
	local v789 = u173(v778, "MenuNodes");
	for v790 = 1, #v788 do
		local v791 = v788[v790];
		if v791:IsA("BasePart") then
			if v791 ~= v785 and v791 ~= v781 then
				local v792 = u157(l__CFrame__787, v791.CFrame);
				local v793 = u64("Weld");
				v793.Part0 = v785;
				v793.Part1 = v791;
				v793.C0 = v792;
				v793.Parent = v785;
				v786[v791.Name] = {
					part = v791, 
					weld = v793, 
					basec0 = v792, 
					basetransparency = v791.Transparency
				};
			end;
			local v794 = u173(v791, "Trail");
			if v794 and v794:IsA("Trail") then
				v782 = v794;
				v782.Enabled = false;
			end;
			v791.Anchored = false;
			v791.CanCollide = false;
		end;
	end;
	u158(p285, v778);
	if v789 then
		v789:Destroy();
	end;
	local v795 = v778:GetChildren();
	for v796 = 1, #v795 do
		local v797 = v795[v796];
		v776.texturedata[v797] = {};
		local v798 = v797:GetChildren();
		for v799 = 1, #v798 do
			local v800 = v798[v799];
			if v800:IsA("Texture") or v800:IsA("Decal") then
				v776.texturedata[v797][v800] = {
					Transparency = v800.Transparency
				};
			end;
		end;
		if v797:IsA("BasePart") then
			v797.CastShadow = false;
		end;
	end;
	v786.camodata = v776.texturedata;
	local v801 = u64("Motor6D");
	v801.Part0 = u164;
	v801.Part1 = v785;
	v801.Parent = v785;
	local v802 = u64("Motor6D");
	v786[l__mainpart__780] = {
		weld = {
			C0 = u15
		}, 
		basec0 = u15
	};
	v786.larm = {
		weld = {
			C0 = v777.larmoffset
		}, 
		basec0 = v777.larmoffset
	};
	v786.rarm = {
		weld = {
			C0 = v777.rarmoffset
		}, 
		basec0 = v777.rarmoffset
	};
	v786.knife = {
		weld = {
			C0 = v777.knifeoffset
		}, 
		basec0 = v777.knifeoffset
	};
	v802.Part0 = u143;
	v802.Part1 = v781;
	v802.Parent = v781;
	local l__equipoffset__803 = v777.equipoffset;
	function v776.destroy(p286)
		if v778:FindFirstChild("Sound") then
			v778.Sound.Parent = nil;
		end;
		v778:Destroy();
	end;
	local u206 = false;
	local u207 = nil;
	local u208 = false;
	local u209 = 1000;
	function v776.setequipped(p287, p288, p289)
		if p288 and (not u206 or not u171) then
			if not char.alive then
				return;
			end;
			hud:setcrosssettings(v777.type, v777.crosssize, v777.crossspeed, v777.crossdamper, l__mainpart__780);
			hud:updatefiremode("KNIFE");
			hud:updateammo("KNIFE");
			sound.play("equipCloth", 0.25);
			sound.play(v777.soundClassification .. "Equip", 0.25);
			u171 = true;
			u207 = false;
			u172:clear();
			if u149 then
				u149:setequipped(false);
			end;
			u172:add(function()
				char:setbasewalkspeed(v777.walkspeed);
				v541.s = v777.sprintspeed;
				hud:setcrosssize(v777.crosssize);
				if v778 then
					v778.Parent = l__CurrentCamera__162;
				end;
				if v782 then
					v782.Enabled = false;
				end;
				if v777.soundClassification == "saber" then
					sound.play("saberLoop", 0.25, 1, v778, false, true);
				end;
				if p289 then
					local v804 = 32;
				else
					v804 = 16;
				end;
				v554.s = v804;
				v554.t = 0;
				u206 = true;
				u149 = p287;
				u171 = false;
				sound.play("equipCloth", 0.25);
				network:send("equip", 3);
				u208 = false;
				char.grenadehold = false;
				if u139 then
					v541.t = 1;
				end;
				if p289 then
					local v805 = 2000;
				else
					v805 = 1000;
				end;
				u209 = v805;
			end);
			if p289 then
				u172:delay(0.05);
				u172:add(function()
					p287:shoot(p289);
				end);
			end;
		elseif not p288 and u206 then
			u208 = false;
			u207 = false;
			v554.t = 1;
			u172:add(animation.reset(v786, 0.1));
			u172:add(function()
				u206 = false;
				local v806 = v778:FindFirstChildOfClass("Sound");
				if v806 then
					v806:Stop();
				end;
				v778.Parent = nil;
				u148 = false;
				u149 = nil;
			end);
		end;
		if p289 == "death" then
			p287:destroy();
		end;
	end;
	function v776.inspecting(p290)
		return u207;
	end;
	function v776.isaiming()
		return false;
	end;
	function v776.playanimation(p291, p292)
		if not u208 and not u171 then
			u172:clear();
			if u148 then
				u172:add(animation.reset(v786, 0.05));
			end;
			u148 = true;
			v541.t = 0;
			if p292 == "inspect" then
				u207 = true;
			end;
			u172:add(animation.player(v786, v777.animations[p292]));
			u172:add(function()
				u172:add(animation.reset(v786, v777.animations[p292].resettime));
				u148 = false;
				u172:add(function()
					if u139 then
						v541.t = 1;
					end;
					u207 = false;
				end);
			end);
		end;
	end;
	function v776.reloadcancel(p293, p294)
		if p294 then
			u172:clear();
			u172:add(animation.reset(v786, 0.2));
			u147 = false;
			u148 = false;
			u172:add(function()
				if u139 then
					v541.t = 1;
				end;
			end);
		end;
	end;
	function v776.dropguninfo(p295)
		return v781.Position;
	end;
	local u210 = 0;
	local u211 = 0;
	local u212 = {};
	function v776.shoot(p296, p297, p298)
		if roundsystem.lock then
			return;
		end;
		if u207 then
			p296:reloadcancel(true);
			u207 = false;
		end;
		if not u208 then
			local v807 = tick();
			network:send("stab");
			u210 = v807 < u210 and u210 or v807;
			v541.t = 0;
			v541.s = 50;
			u208 = true;
			u147 = true;
			if v782 then
				v782.Enabled = true;
			end;
			if u148 then
				u172:add(animation.reset(v786, 0.1));
				u148 = false;
			end;
			if p297 then
				local v808 = "quickstab";
			else
				v808 = p298 or "stab1";
			end;
			sound.play(v777.soundClassification, 0.25);
			u211 = tick() + v777.hitdelay[v808];
			u212 = {};
			u172:add(animation.player(v786, v777.animations[v808]));
			u172:add(function()
				u172:add(animation.reset(v786, v777.animations[v808].resettime));
			end);
			if u139 or v808 == "quickstab" then
				u172:delay(v777.animations[v808].resettime * 0.75);
				u172:add(function()
					if u139 then
						v541.t = 1;
					end;
				end);
			end;
			local l__s__213 = v541.s;
			u172:add(function()
				u208 = false;
				v541.s = l__s__213;
				u147 = false;
				if v782 then
					v782.Enabled = false;
				end;
			end);
		end;
	end;
	local l__damage1__214 = v777.damage1;
	local l__damage0__215 = v777.damage0;
	local u216 = v778[v777.tip];
	local u217 = v778[v777.blade];
	local function u218(p299, p300, p301, p302, p303)
		local v809 = nil;
		if not u212[p299.Parent] and not u212[p299] then
			if p299.Name == "Window" then
				effects:breakwindow(p299, p300, p301, Vector3.new(), nil, time, p302.Origin, p302.Direction);
				v809 = p299;
			elseif p299.Parent.Name == "Dead" then
				effects:bloodhit(p299.Position, p299.CFrame.lookVector);
				v809 = p299.Parent;
			elseif p299:IsDescendantOf(l__Players__204) then
				local v810 = replication.getplayerhit(p299);
				local v811 = u173(p299.Parent, "Torso");
				if v810 and v810.TeamColor ~= l__LocalPlayer__537.TeamColor and u173(p299.Parent, "Head") and v811 then
					local v812 = (u132(v811.CFrame.lookVector, (p300 - u143.Position).unit) * 0.5 + 0.5) * (l__damage1__214 - l__damage0__215) + l__damage0__215;
					if v812 > 100 then

					end;
					if p299.Name == "Head" then
						v812 = v812 * v777.multhead;
					elseif p299.Name == "Torso" then
						v812 = v812 * v777.multtorso;
					end;
					network:send("knifehit", v810, tick(), p299);
					hud:firehitmarker(p299.Name == "Head");
					effects:bloodhit(p300, true, v812, Vector3.new(0, -8, 0) + (p300 - u143.Position).unit * 8);
				end;
				v809 = p299.Parent;
			elseif p303 then
				effects:bullethit(p299, p300, p301);
				v809 = p299;
			end;
			if v809 then
				u212[v809] = true;
			end;
		end;
	end;
	local l__mainoffset__219 = v777.mainoffset;
	local u220 = cframe.interpolator(v777.proneoffset);
	local u221 = cframe.interpolator(v777.sprintoffset);
	function v776.step(p304)
		if u208 then
			local v813 = replication.getallparts();
			v813[#v813 + 1] = l__Map__205;
			local l__p__814 = u216.CFrame.p;
			local v815 = u217.CFrame.p - l__p__814;
			local l__Magnitude__816 = v815.Magnitude;
			for v817 = 0, l__Magnitude__816, 0.1 do
				local v818 = u152(camera.cframe.p, l__p__814 + v817 / l__Magnitude__816 * v815 - camera.cframe.p);
				local v819, v820, v821 = workspace:FindPartOnRayWithWhitelist(v818, v813);
				if v819 then
					u218(v819, v820, v821, v818, v817 == 0);
				end;
			end;
		end;
		local v822 = u143.CFrame:inverse() * camera.shakecframe * l__mainoffset__219 * v786[l__mainpart__780].weld.C0 * u220(v550.p) * u41(0, 0, 1) * cframe.fromaxisangle(v547.v) * u41(0, 0, -1) * u174(0.7, 1) * u175(0) * cframe.interpolate(u221(v553.p / v556.p * v541.p), v777.equipoffset, v554.p);
		v802.C0 = v822;
		u166.C0 = v822 * cframe.interpolate(v786.larm.weld.C0, v777.larmsprintoffset, v553.p / v556.p * v541.p);
		u165.C0 = v822 * cframe.interpolate(v786.rarm.weld.C0, v777.rarmsprintoffset, v553.p / v556.p * v541.p);
		v801.C0 = v786.knife.weld.C0;
		v779:step();
		if not char.alive then
			v776:setequipped(false);
		end;
	end;
	return v776;
end;
local function u222(p305)
	for v823 = 1, u136 do
		if u137[v823] == p305 then
			warn("Error, tried to add gun twice");
			return;
		end;
	end;
	u136 = u136 + 1;
	u137[u136] = p305;
	p305.id = u136;
	return u136;
end;
local function u223(p306)
	local v824 = nil;
	for v825 = 1, u136 do
		if u137[v825] == p306 then
			v824 = true;
			break;
		end;
	end;
	if not v824 then
		warn("Error, tried to remove gun twice");
		return;
	end;
	local l__id__826 = p306.id;
	p306.id = nil;
	u137[l__id__826] = u137[u136];
	u137[u136] = nil;
	u136 = u136 - 1;
	local v827 = u137[l__id__826];
	if v827 then
		v827.id = l__id__826;
	end;
end;
local l__PlayerGui__224 = l__LocalPlayer__537.PlayerGui;
local u225 = shared.require("InputType");
local u226 = function(p307, p308)
	return p307 + Vector3.new(u170(), u170(), u170()) * (p308 - p307);
end;
local u227 = 0;
local function u228()
	sound.play("1PsniperBass", 0.75);
	sound.play("1PsniperEcho", 1);
end;
local u229 = UDim2.new;
function char.loadgun(p309, p310, p311, p312, p313, p314, p315)
	local v828 = ModifyData(u52(p309), p312, p313);
	local v829 = l__getGunModel__125(p309):Clone();
	local v830 = {
		burst = 0, 
		auto = false, 
		attachments = p312, 
		camodata = p314, 
		texturedata = {}, 
		transparencydata = {}, 
		data = v828, 
		type = v828.type, 
		ammotype = v828.ammotype, 
		name = v828.name, 
		magsize = v828.magsize, 
		sparerounds = v828.sparerounds, 
		gunnumber = p315
	};
	local v831 = sequencer.new();
	local l__mainpart__832 = v828.mainpart;
	local v833 = v829[l__mainpart__832];
	local v834 = u167(v829, v833, p312, v828, p314, p313);
	local v835 = math.ceil(p311 or v828.sparerounds);
	local l__magsize__836 = v828.magsize;
	u222(v830);
	function v830.remove(p316)
		u223(p316);
	end;
	local v837 = v829:GetChildren();
	for v838 = 1, #v837 do
		local v839 = v837[v838];
		v830.texturedata[v839] = {};
		v830.transparencydata[v839] = v839.Transparency;
		local v840 = v839:GetChildren();
		for v841 = 1, #v840 do
			local v842 = v840[v841];
			if v842:IsA("Texture") or v842:IsA("Decal") then
				v830.texturedata[v839][v842] = {
					Transparency = v842.Transparency
				};
			end;
		end;
		if v839.Name == "LaserLight" then
			u9:addlaser(v839);
		end;
		if v839:IsA("BasePart") then
			v839.CastShadow = false;
		end;
	end;
	v834.camodata = v830.texturedata;
	local v843 = u64("Motor6D");
	v834[l__mainpart__832] = {
		part = v833, 
		basetransparency = v833.Transparency, 
		weld = {
			C0 = u15
		}, 
		basec0 = u15
	};
	v834.larm = {
		weld = {
			C0 = v828.larmoffset
		}, 
		basec0 = v828.larmoffset
	};
	v834.rarm = {
		weld = {
			C0 = v828.rarmoffset
		}, 
		basec0 = v828.rarmoffset
	};
	local v844 = v829[v828.barrel];
	v830.barrel = v844;
	local v845 = v829[v828.sight];
	if v828.altsight then
		local v846 = v829[v828.altsight];
	end;
	local l__hideminimap__847 = v828.hideminimap;
	if v828.hiderange then

	end;
	local v848 = math.pi / 180;
	local v849 = cframe.interpolator(v828.sprintoffset);
	local v850 = cframe.interpolator(v828.climboffset or CFrame.new(-0.9, -1.48, 0.43) * CFrame.Angles(-0.5, 0.3, 0));
	local v851 = cframe.interpolator(char.disabledynamicstance and CFrame.new() or (v828.crouchoffset or CFrame.new(-0.45, 0.1, 0.1) * CFrame.Angles(0, 0, 30 * v848)));
	local v852 = cframe.interpolator(char.disabledynamicstance and CFrame.new() or CFrame.new(-0.3, 0.25, 0.2) * CFrame.Angles(0, 0, 10 * v848));
	local v853 = cframe.interpolator(v834[v828.bolt].basec0, v834[v828.bolt].basec0 * v828.boltoffset);
	local v854 = spring.new(u131);
	local v855 = spring.new(u131);
	local v856 = spring.new(u131);
	local v857 = spring.new(0);
	v857.s = 12;
	local v858 = {};
	v830.aimsightdata = v858;
	local u230 = {};
	local u231 = 1;
	local u232 = v828.variablefirerate and v828.firerate[1] or v828.firerate;
	local u233 = 1;
	local u234 = false;
	local function v859()
		u230 = v858[u231];
		u232 = u230.variablefirerate and u230.firerate[u233] or u230.firerate;
		for v860 = 1, #v858 do
			if u234 then
				local v861 = v860 == u231 and v545.t or 0;
			else
				v861 = 0;
			end;
			v858[v860].sightspring.t = v861;
			v858[v860].sightspring.s = u230.aimspeed;
		end;
		u140 = u234 and u230.aimwalkspeedmult or 1;
		camera.shakespring.s = u234 and u230.aimcamkickspeed or v828.camkickspeed;
		if u230.blackscope then
			hud:setscopesettings(u230);
		end;
		hud:updatesightmark(u230.sightpart, u230.centermark);
		u146();
	end;
	local u235 = {
		sight = v828.sight, 
		sightpart = v829[v828.sight], 
		aimoffset = CFrame.new(), 
		aimrotkickmin = v828.aimrotkickmin, 
		aimrotkickmax = v828.aimrotkickmax, 
		aimtranskickmin = v828.aimtranskickmin * Vector3.new(1, 1, 0.5), 
		aimtranskickmax = v828.aimtranskickmax * Vector3.new(1, 1, 0.5), 
		larmaimoffset = v828.larmaimoffset, 
		rarmaimoffset = v828.rarmaimoffset, 
		aimcamkickmin = v828.aimcamkickmin, 
		aimcamkickmax = v828.aimcamkickmax, 
		aimcamkickspeed = v828.aimcamkickspeed, 
		aimspeed = v828.aimspeed, 
		aimwalkspeedmult = v828.aimwalkspeedmult, 
		magnifyspeed = v828.magnifyspeed, 
		zoom = v828.zoom, 
		prezoom = v828.prezoom or v828.zoom ^ 0.25, 
		scopebegin = v828.scopebegin and 0.9, 
		firerate = v828.firerate, 
		aimedfirerate = v828.aimedfirerate, 
		variablefirerate = v828.variablefirerate, 
		onfireanim = v828.onfireanim and "", 
		aimreloffset = v828.aimreloffset, 
		aimzdist = v828.aimzdist, 
		aimzoffset = v828.aimzoffset, 
		aimspringcancel = v828.aimspringcancel, 
		sightsize = v828.sightsize, 
		sightr = v828.sightr, 
		nosway = v828.nosway, 
		swayamp = v828.swayamp, 
		swayspeed = v828.swayspeed, 
		steadyspeed = v828.steadyspeed, 
		breathspeed = v828.breathspeed, 
		recoverspeed = v828.recoverspeed, 
		scopeid = v828.scopeid, 
		scopecolor = v828.scopecolor, 
		sightcolor = v828.sightcolor, 
		scopelenscolor = v828.lenscolor, 
		scopelenstrans = v828.lenstrans, 
		scopeimagesize = v828.scopeimagesize, 
		scopesize = v828.scopesize, 
		reddot = v828.reddot, 
		midscope = v828.midscope, 
		blackscope = v828.blackscope, 
		centermark = v828.centermark, 
		pullout = v828.pullout, 
		zoompullout = v828.zoompullout
	};
	local l__mainoffset__236 = v828.mainoffset;
	local l__CFrame_new__237 = CFrame.new;
	local function v862(p317)
		local v863 = {};
		for v864, v865 in next, u235 do
			v863[v864] = v865;
		end;
		for v866, v867 in next, p317 do
			v863[v866] = v867;
		end;
		if v829:FindFirstChild(v863.sight) then
			local v868 = l__mainoffset__236:inverse() * v829[v863.sight].CFrame:inverse() * v833.CFrame;
			local v869 = (v868 - (v863.aimzdist and Vector3.new(0, 0, v863.aimzdist + (v863.aimzoffset and 0)) or v868.p * Vector3.new(0, 0, 1) - Vector3.new(0, 0, 0))) * (v863.aimreloffset or l__CFrame_new__237());
			v863.sightpart = v829[v863.sight];
			v863.aimoffset = v869;
			v863.aimoffsetp = v869.p;
			v863.aimoffsetr = cframe.toaxisangle(v869);
			v863.larmaimoffsetp = v863.larmaimoffset.p;
			v863.larmaimoffsetr = cframe.toaxisangle(v863.larmaimoffset);
			v863.rarmaimoffsetp = v863.rarmaimoffset.p;
			v863.rarmaimoffsetr = cframe.toaxisangle(v863.rarmaimoffset);
			v863.sightspring = spring.new(0);
			v858[#v858 + 1] = v863;
		end;
	end;
	v862(u235);
	for v870, v871 in next, v828.altaimdata or {} do
		v862(v871);
	end;
	v859();
	u235 = spring.new;
	u235 = u235();
	v854.s = v828.modelkickspeed;
	v855.s = v828.modelkickspeed;
	v854.d = v828.modelkickdamper;
	v855.d = v828.modelkickdamper;
	v856.s = v828.hipfirespreadrecover;
	v856.d = v828.hipfirestability and 0.7;
	v545.d = 0.95;
	u235.s = 16;
	u235.d = 0.95;
	function v830.destroy(p318, p319)
		p318:remove();
		u9:deactivatelasers(p319, v829);
		u9:destroysights(p319, v829);
		v829:Destroy();
	end;
	local u238 = 0;
	local u239 = v828.firemodes;
	local u240 = false;
	local u241 = p310 and l__magsize__836;
	local u242 = v835;
	local u243 = function()
		u238 = u239[u233] == 3 and (v828.fmode3 and 0.2) or (u239[u233] == 2 and (v828.fmode2 and 0.3) or v828.fmode1 and 0);
	end;
	local u244 = false;
	local u245 = nil;
	local u246 = false;
	local u247 = true;
	local u248 = 0;
	local u249 = false;
	function v830.setequipped(p320, p321, p322)
		if p322 then
			p320:hide();
		end;
		if p321 and (not u240 or not u171) then
			if not char.alive then
				return;
			else
				network:send("equip", p320.gunnumber);
				hud:setcrosssettings(v828.type, v828.crosssize, v828.crossspeed, v828.crossdamper, u230.sightpart, u230.centermark);
				hud:updatefiremode(u239[u233]);
				hud:updateammo(u241, u242);
				u243();
				p320:setaim(false);
				u171 = true;
				u147 = false;
				sound.play("equipCloth", 0.25);
				u244 = false;
				u245 = false;
				u172:clear();
				if u149 then
					u149:setequipped(false);
				end;
				u172:add(function()
					char:setbasewalkspeed(v828.walkspeed);
					v541.s = v828.sprintspeed;
					camera.magspring.s = v828.magnifyspeed;
					camera.shakespring.s = v828.camkickspeed;
					hud:setcrosssize(v828.crosssize);
					camera:setswayspeed(u230.swayspeed and 1);
					camera.swayspring.s = u230.steadyspeed and 4;
					camera:setsway(0);
					v545.s = u230.aimspeed;
					u235.s = u230.aimspeed;
					u9:activatelasers(false, v829);
					v554.s = v828.equipspeed and 12;
					v554.t = 0;
					v857.t = 0;
					local v872 = v833:GetChildren();
					for v873 = 1, #v872 do
						if v872[v873]:IsA("Weld") and (not v872[v873].Part1 or v872[v873].Part1.Parent ~= v829) then
							v872[v873]:Destroy();
						end;
					end;
					if v829 then
						v829.Parent = l__CurrentCamera__162;
					end;
					v843.Part0 = u143;
					v843.Part1 = v833;
					v843.Parent = v833;
					u240 = true;
					u171 = false;
					sound.play("equipCloth", 0.25);
					sound.play("equipGear", 0.1);
					if u246 then
						v834[v828.bolt].weld.C0 = v853(1);
					end;
					if not u247 and tick() < u248 then
						p320:chambergun();
					else
						u247 = true;
						if input.mouse.down.right or input.controller.down.l2 then
							p320:setaim(true);
						end;
						if u139 then
							v541.t = 1;
						end;
					end;
					u149 = p320;
					char.grenadehold = false;
				end);
				return;
			end;
		end;
		if not p321 and u240 then
			local l__next__874 = next;
			local v875, v876 = v844:GetChildren();
			while true do
				local v877, v878 = l__next__874(v875, v876);
				if not v877 then
					break;
				end;
				v876 = v877;
				if v878:IsA("Sound") then
					v878:Stop();
				end;			
			end;
			if u234 then
				p320:setaim(false);
			end;
			p320.auto = false;
			if not v828.burstcam then
				p320.burst = 0;
			end;
			u147 = false;
			u245 = false;
			v554.t = 1;
			effects:applyeffects(v828.effectsettings, false);
			u172:clear();
			u172:add(animation.reset(v834, 0.2, v828.keepanimvisibility));
			u172:add(function()
				camera:magnify(1);
				u9:deactivatelasers(p322, v829);
				u9:destroysights(p322, v829);
				u240 = false;
				v843.Part1 = nil;
				v829.Parent = nil;
				u148 = false;
				u249 = false;
				u149 = nil;
			end);
		end;
	end;
	local u250 = nil;
	function v830.toggleattachment(p323)
		u231 = u231 % #v858 + 1;
		v859();
		if not u247 and u250 and not u230.blackscope and v828.animations.onfire then
			p323:chambergun();
		end;
	end;
	local u251 = false;
	local u252 = function(p324, p325)
		local v879 = p324:GetChildren();
		for v880 = 1, #v879 do
			local v881 = v879[v880];
			if v881:IsA("Texture") or v881:IsA("Decal") then
				v881.Transparency = p325 ~= 1 and v830.texturedata[p324][v881].Transparency or 1;
			elseif v881:IsA("SurfaceGui") then
				v881.Enabled = p325 ~= 1;
			end;
		end;
	end;
	function v830.hide(p326, p327)
		if p327 then
			if u251 then
				return;
			end;
			u251 = true;
			local v882 = v829:GetChildren();
			for v883 = 1, #v882 do
				local v884 = v882[v883];
				if (not (not u173(v884, "Mesh")) or not (not v884:IsA("UnionOperation")) or v884:IsA("MeshPart")) and (not v828.invisible or not v828.invisible[v884.Name]) then
					v884.Transparency = 1;
					u252(v884, 1);
				end;
			end;
			u252(u230.sightpart, 1);
			local v885 = u160:GetChildren();
			for v886 = 1, #v885 do
				local v887 = v885[v886];
				if not (not u173(v887, "Mesh")) or not (not v887:IsA("UnionOperation")) or not (not v887:IsA("MeshPart")) or v887:IsA("BasePart") then
					v887.Transparency = 1;
				end;
			end;
			local v888 = u161:GetChildren();
			for v889 = 1, #v888 do
				local v890 = v888[v889];
				if not (not u173(v890, "Mesh")) or not (not v890:IsA("UnionOperation")) or not (not v890:IsA("MeshPart")) or v890:IsA("BasePart") then
					v890.Transparency = 1;
				end;
			end;
		end;
	end;
	function v830.inspecting(p328)
		return u245;
	end;
	function v830.isblackscope(p329)
		return u230.blackscope;
	end;
	local u253 = nil;
	function v830.show(p330, p331)
		if not u251 or u253 then
			return;
		end;
		u251 = false;
		local v891 = v829:GetChildren();
		for v892 = 1, #v891 do
			local v893 = v891[v892];
			if (not (not u173(v893, "Mesh")) or not (not v893:IsA("UnionOperation")) or not (not v893:IsA("MeshPart")) or u173(v893, "Bar")) and (not v828.invisible or not v828.invisible[v893.Name]) then
				v893.Transparency = p330.transparencydata[v893];
				u252(v893, 0);
			end;
		end;
		for v894, v895 in next, v858 do
			u252(v895.sightpart, 0);
		end;
		local v896 = u160:GetChildren();
		for v897 = 1, #v896 do
			local v898 = v896[v897];
			if not (not u173(v898, "Mesh")) or not (not v898:IsA("UnionOperation")) or not (not v898:IsA("MeshPart")) or v898:IsA("BasePart") then
				v898.Transparency = 0;
			end;
		end;
		local v899 = u161:GetChildren();
		for v900 = 1, #v899 do
			local v901 = v899[v900];
			if not (not u173(v901, "Mesh")) or not (not v901:IsA("UnionOperation")) or not (not v901:IsA("MeshPart")) or v901:IsA("BasePart") then
				v901.Transparency = 0;
			end;
		end;
	end;
	function v830.updatescope(p332)
		if u253 and not u250 then
			u250 = true;
			p332:hide(true);
			hud:setscope(true, u230.nosway);
			effects:applyeffects(v828.effectsettings, true);
			return;
		end;
		if not u253 and u250 then
			u250 = false;
			p332:show();
			hud:setscope(false);
			effects:applyeffects(v828.effectsettings, false);
		end;
	end;
	function v830.isaiming()
		return u234;
	end;
	function v830.setaim(p333, p334)
		if not (not u147) or not u240 or v828.forcehip then
			return;
		end;
		if p334 and (not u244 or v828.straightpull) then
			network:send("aim", true);
			u234 = true;
			u139 = false;
			v541.t = 0;
			network:send("sprint", u139);
			u140 = u230.aimwalkspeedmult;
			camera.shakespring.s = u230.aimcamkickspeed;
			camera:setaimsensitivity(true);
			hud:setcrosssize(0);
			sound.play("aimGear", 0.15);
			v545.t = 1;
			if u249 and u230.zoompullout and u230.aimspringcancel then
				local v902 = 0;
			elseif u249 and u230.zoompullout and not u230.blackscope then
				v902 = 0.5;
			else
				v902 = 1;
			end;
			v546.t = v902;
			if u249 and u230.zoompullout then
				local v903 = 0;
			else
				v903 = 1;
			end;
			u235.t = v903;
			v859();
		elseif not p334 then
			if u234 and u230.blackscope then
				v831:clear();
			end;
			u53.setsprintdisable(false);
			u234 = false;
			sound.play("aimCloth", 0.15);
			network:send("aim", false);
			hud:setcrosssize(v828.crosssize);
			camera.shakespring.s = v828.camkickspeed;
			u140 = 1;
			camera:setaimsensitivity(false);
			v545.t = 0;
			v546.t = 0;
			u235.t = 0;
			v859();
			v831:add(function()
				if not u234 and u241 == 0 and u242 > 0 and not u147 then
					p333:reload();
				end;
			end);
			if u241 > 0 and not u247 and not u244 and v828.animations.onfire and u230.pullout then
				u148 = true;
				u249 = true;
				u244 = true;
				v857.t = 1;
				u172:add(animation.player(v834, v828.animations.onfire));
				u172:add(function()
					u247 = true;
					u172:add(animation.reset(v834, v828.animations.onfire.resettime, v828.keepanimvisibility or u234));
					u172:add(function()
						u148 = false;
						u249 = false;
						u244 = false;
						v857.t = 0;
						if u139 then
							v541.t = 1;
						end;
						if input.mouse.down.right or input.controller.down.l2 then
							p333:setaim(true);
						end;
					end);
				end);
			end;
			if not u230.blackscope then
				char:setsprint(input.keyboard.down.leftshift or input.keyboard.down.w and u173(l__PlayerGui__224, "Doubletap"));
			end;
		end;
		u146();
	end;
	function v830.chambergun(p335)
		print("pretend to chamber gun");
		if not (u241 > 0) or not v828.animations.pullbolt then
			u247 = true;
			return;
		end;
		u147 = true;
		u249 = true;
		if u139 then
			v541.t = 0;
		end;
		u172:add(animation.player(v834, v828.animations.pullbolt));
		u172:add(function()
			u247 = true;
			u172:add(animation.reset(v834, v828.animations.pullbolt.resettime, v828.keepanimvisibility or u234));
			u172:add(function()
				u148 = false;
				u249 = false;
				u147 = false;
				if u139 then
					v541.t = 1;
				end;
				if input.mouse.down.right or input.controller.down.l2 then
					p335:setaim(true);
				end;
			end);
		end);
	end;
	function v830.playanimation(p336, p337)
		if not (not u147) or not (not u171) or not (not u249) then
			return true;
		end;
		u172:clear();
		if u148 then
			u172:add(animation.reset(v834, 0.05, v828.keepanimvisibility));
		end;
		if u234 and p337 ~= "selector" then
			p336:setaim(false);
		end;
		u148 = true;
		v541.t = 0;
		local v904 = {};
		if p337 == "inspect" then
			u245 = true;
		end;
		v857.t = 1;
		u172:add(animation.player(v834, v828.animations[p337]));
		u172:add(function()
			u172:add(animation.reset(v834, v828.animations[p337].resettime, v828.keepanimvisibility or u253));
			u172:add(function()
				u245 = false;
				u148 = false;
				if u147 then
					return;
				end;
				if (input.mouse.down.right or input.controller.down.l2) and not u234 then
					p336:setaim(true);
				end;
				if u139 then
					v541.t = 1;
				end;
				v857.t = 0;
			end);
		end);
	end;
	function v830.dropguninfo(p338)
		return u241, u242, v833.Position;
	end;
	function v830.addammo(p339, p340, p341)
		u242 = u242 + p340;
		hud:updateammo(u241, u242);
		u106:customaward("Picked up " .. p340 .. " rounds from dropped " .. p341);
	end;
	function v830.reloadcancel(p342, p343)
		if u147 or p343 then
			u172:clear();
			u172:add(animation.reset(v834, 0.2, v828.keepanimvisibility));
			u147 = false;
			u148 = false;
			u245 = false;
			v857.t = 0;
			if not u247 then
				p342:chambergun();
				return;
			end;
			if input.mouse.down.right or input.controller.down.l2 then
				p342:setaim(true);
			end;
			if u139 then
				v541.t = 1;
			end;
		end;
	end;
	local l__chamber__254 = v828.chamber;
	local u255 = l__magsize__836;
	function v830.reload(p344)
		if not u249 and not u171 and not u147 and u242 > 0 and u241 ~= (l__chamber__254 and u255 + 1 or u255) then
			if u148 then
				u172:clear();
				v831:clear();
				u172:add(animation.reset(v834, 0.1, v828.keepanimvisibility));
			end;
			if u234 then
				p344:setaim(false);
			end;
			u245 = false;
			u148 = true;
			u147 = true;
			v541.t = 0;
			p344.auto = false;
			p344.burst = 0;
			v857.t = 1;
			if v828.type == "SHOTGUN" and not v828.magfeed == true then
				u172:add(animation.player(v834, v828.animations.tacticalreload));
				u172:add(function()
					u241 = u241 + 1;
					u242 = u242 - 1;
					u247 = true;
					network:send("reload");
					hud:updateammo(u241, u242);
				end);
				local v905 = u242 - 1;
				if u241 < u255 and u242 > 0 and v905 > 0 then
					for v906 = 2, u255 - u241 do
						if u242 > 0 and v905 > 0 then
							v905 = v905 - 1;
							u172:add(animation.player(v834, v828.altreload and v828.animations[v828.altreload .. "reload"] or v828.animations.reload));
							u172:add(function()
								u241 = u241 + 1;
								u242 = u242 - 1;
								network:send("reload");
								hud:updateammo(u241, u242);
							end);
						end;
					end;
				end;
				if u241 == 0 then
					u172:add(animation.player(v834, v828.animations.pump));
				end;
				local u256 = true;
				u172:add(function()
					if u256 and v828.animations.tacticalreload.resettime then
						local v907 = v828.animations.tacticalreload.resettime;
						if not v907 then
							if not u256 then
								v907 = v828.animations.reload.resettime and v828.animations.reload.resettime or 0.5;
							else
								v907 = 0.5;
							end;
						end;
					elseif not u256 then
						v907 = v828.animations.reload.resettime and v828.animations.reload.resettime or 0.5;
					else
						v907 = 0.5;
					end;
					u172:add(animation.reset(v834, v907), v828.keepanimvisibility);
					u172:add(function()
						v857.t = 0;
						u147 = false;
						u148 = false;
						u245 = false;
						u246 = false;
						u247 = true;
						if u139 then
							v541.t = 1;
						end;
						if input.mouse.down.right or input.controller.down.l2 then
							p344:setaim(true);
						end;
					end);
				end);
			elseif v828.animations.uniquereload then
				local v908 = u241 == 0;
				if v828.animations.initstage then
					u172:add(animation.player(v834, v828.animations.initstage));
				elseif v908 then
					v908 = true;
					if v828.animations.initemptystage then
						u172:add(animation.player(v834, v828.animations.initemptystage));
					end;
				end;
				local v909 = u242;
				if u241 < u255 and u242 > 0 and v909 > 0 then
					for v910 = 1, u255 - u241 do
						if u242 > 0 and v909 > 0 then
							v909 = v909 - 1;
							if v828.animations.reloadstage then
								u172:add(animation.player(v834, v828.animations.reloadstage));
							end;
							u172:add(function()
								u241 = u241 + 1;
								u242 = u242 - 1;
								network:send("reload");
								hud:updateammo(u241, u242);
							end);
						end;
					end;
				end;
				if v908 then
					if v828.animations.emptyendstage then
						u172:add(animation.player(v834, v828.animations.emptyendstage));
					end;
				elseif v828.animations.endstage then
					u172:add(animation.player(v834, v828.animations.endstage));
				end;
				u172:add(function()
					u172:add(animation.reset(v834, v908 and v828.animations.emptyendstage.resettime and v828.animations.emptyendsstage.resettime or (not v908 and v828.animations.endstage.resettime and v828.animations.endstage.resettime or 0.5)), v828.keepanimvisibility);
					u172:add(function()
						v857.t = 0;
						u147 = false;
						u148 = false;
						u245 = false;
						u246 = false;
						u247 = true;
						if u139 then
							v541.t = 1;
						end;
						if input.mouse.down.right or input.controller.down.l2 then
							p344:setaim(true);
						end;
					end);
				end);
			else
				if u241 == 0 then
					local v911 = v828.altreloadlong and v828.animations[v828.altreloadlong .. "reload"] or v828.animations.reload;
				else
					v911 = v828.altreload and v828.animations[v828.altreload .. "tacticalreload"] or v828.animations.tacticalreload;
				end;
				u172:add(animation.player(v834, v911));
				u172:add(function()
					u242 = u242 + u241;
					local v912 = (u241 == 0 or not l__chamber__254) and u255 or u255 + 1;
					u241 = u242 < v912 and u242 or v912;
					u242 = u242 - u241;
					u246 = false;
					network:send("reload");
					hud:updateammo(u241, u242);
					u172:add(animation.reset(v834, v911.resettime and 0.5, v828.keepanimvisibility));
					u172:add(function()
						v857.t = 0;
						u147 = false;
						u148 = false;
						u245 = false;
						u247 = true;
						if u139 then
							v541.t = 1;
						end;
						if input.mouse.down.right or input.controller.down.l2 then
							p344:setaim(true);
						end;
					end);
				end);
			end;
		end;
	end;
	function v830.memes(p345)
		u255 = 2 * u255;
		u241 = u255;
		u242 = 1000000;
		u232 = 1000;
		u239 = { true, 1, 2, 3 };
		for v913 = 1, #v858 do
			local v914 = v858[v913];
			v914.firerate = u232;
			v914.variablefirerate = nil;
		end;
	end;
	local u257 = 0;
	local u258 = 0;
	function v830.shoot(p346, p347)
		if p347 then
			if roundsystem.lock then
				return;
			end;
			if u241 == 0 then
				p346:reload();
			end;
			if not u247 then
				return;
			end;
			if u147 and u241 > 0 then
				p346:reloadcancel();
				return;
			end;
			if not u147 and not u171 then
				local v915 = u239[u233];
				local v916 = tick();
				char:setsprint(false);
				if v915 == true then
					p346.auto = true;
				elseif p346.burst == 0 and u257 < v916 then
					p346.burst = v915;
				end;
				if v828.burstcam then
					p346.auto = true;
				end;
				if u257 < v916 then
					u257 = v916;
					return;
				end;
			end;
		elseif not v828.loosefiring then
			local v917 = tick();
			if v828.autoburst and p346.auto and u258 > 0 then
				u257 = v917 + 60 / v828.firecap;
			end;
			u258 = 0;
			p346.auto = false;
			if not v828.burstlock and not v828.burstcam then
				p346.burst = 0;
			end;
		end;
	end;
	function v830.nextfiremode(p348)
		if u147 then
			return;
		end;
		local l__zoom__918 = u230.zoom;
		if v828.animations.selector then
			if u148 then
				u172:clear();
				u172:add(animation.reset(v834, 0.2, v828.keepanimvisibility));
			end;
			u148 = true;
			if u234 and not u230.aimspringcancel then
				v546.t = 0.5;
				u235.t = 0;
				v859();
			end;
			if u139 then
				v541.t = 0.5;
			end;
			u249 = true;
			u172:add(animation.player(v834, v828.animations.selector));
			u172:add(function()
				u172:add(animation.reset(v834, v828.animations.selector.resettime, v828.keepanimvisibility or u253));
				u148 = false;
				u245 = false;
				u249 = false;
				if u139 then
					v541.t = 1;
				end;
				if u234 then
					v546.t = 1;
					u235.t = 1;
					v859();
				end;
			end);
		end;
		u172:add(function()
			u233 = u233 % #u239 + 1;
			hud:updatefiremode(u239[u233]);
			if u230.variablefirerate then
				u232 = u230.firerate[u233];
			end;
			if p348.auto then
				p348.auto = false;
			end;
			u243();
			return u239[u233];
		end);
	end;
	u243 = function(p349)
		p349 = p349 / v828.bolttime * 1.5;
		u246 = false;
		if p349 > 1.5 then
			v834[v828.bolt].weld.C0 = v853(0);
			return nil;
		end;
		if not (p349 > 0.5) then
			v834[v828.bolt].weld.C0 = v853(1 - 4 * (p349 - 0.5) * (p349 - 0.5));
			return false;
		end;
		p349 = (p349 - 0.5) * 0.5 + 0.5;
		v834[v828.bolt].weld.C0 = v853(1 - 4 * (p349 - 0.5) * (p349 - 0.5));
		return false;
	end;
	u252 = function(p350)
		p350 = p350 / v828.bolttime * 1.5;
		if p350 > 0.5 then
			v834[v828.bolt].weld.C0 = v853(1);
			u246 = true;
			return true;
		end;
		v834[v828.bolt].weld.C0 = v853(1 - 4 * (p350 - 0.5) * (p350 - 0.5));
		u246 = false;
		return false;
	end;
	local l__range0__259 = v828.range0;
	local l__damage0__260 = v828.damage0;
	local l__range1__261 = v828.range1;
	local l__damage1__262 = v828.damage1;
	for v919, v920 in next, v858 do
		if v920.reddot then
			v920.sightpart.Transparency = 1;
			u9:addreddot(v920.sightpart);
		elseif v920.midscope then
			u9:addscope(v920);
		elseif v920.blackscope then
			u9:addscope(v920);
		end;
	end;
	local function u263()
		if tick() < u257 or not u240 or roundsystem.lock then
			return false;
		end;
		if v828.burstcam then
			return v830.auto and v830.burst > 0;
		end;
		return v830.auto or v830.burst > 0;
	end;
	local function u264(p351, p352, p353, p354, p355, p356)
		if char.alive then
			if p353.Parent then
				if p352.TeamColor == l__LocalPlayer__537.TeamColor then
					return;
				end;
			else
				warn(string.format("We hit a bodypart that doesn't exist %s %s", l__LocalPlayer__537.Name, p353.Name));
				return;
			end;
		else
			return;
		end;
		local l__Magnitude__921 = (p351.origin - p354).Magnitude;
		local v922 = l__Magnitude__921 < l__range0__259 and l__damage0__260 or (l__Magnitude__921 < l__range1__261 and (l__damage1__262 - l__damage0__260) / (l__range1__261 - l__range0__259) * (l__Magnitude__921 - l__range0__259) + l__damage0__260 or l__damage1__262);
		hud:firehitmarker(p353.Name == "Head");
		effects:bloodhit(p354, true, p353.Name == "Head" and v922 * v828.multhead or (p353.Name == "Torso" and v922 * v828.multtorso or v922), p351.velocity / 10);
		sound.PlaySound("hitmarker", nil, 1, 1.5);
		if not p356 then
			network:send("bullethit", p352, p354, p353, p355);
			return;
		end;
		table.insert(p356, { p352, p354, p353, p355 });
	end;
	local function u265(p357, p358, p359, p360, p361, p362, p363, p364, p365)
		if p358:IsDescendantOf(workspace.Ignore.DeadBody) then
			effects:bloodhit(p359);
			return;
		end;
		if p358.Anchored then
			if p358.Name == "Window" then
				effects:breakwindow(p358, p359, p360, p357.velocity, Vector3.new(), p365, p363, p364);
			end;
			if p358.Name == "Hitmark" then
				hud:firehitmarker();
			elseif p358.Name == "HitmarkHead" then
				hud:firehitmarker(true);
			end;
			effects:bullethit(p358, p359, p360, p361, p362, p357.velocity, true, true, math.random(0, 2));
		end;
	end;
	local l__hideflash__266 = v828.hideflash;
	local function u267()
		if u9.sighttable then
			u9.sighteffect(true, v829, hud);
			if v545.p > 0.5 then
				local v923 = u9.activedot or (u9.activescope or u230.sightpart);
			else
				v923 = u230.sightpart;
			end;
			hud:updatesightmark(v923, u230.centermark);
			hud:updatescopemark(u9.activescope);
		end;
		if u9.lasertable then
			u9.lasereffect();
		end;
	end;
	local function u268(p366)
		local v924 = tick();
		while true do
			local u269 = nil;
			local u270 = nil;
			if not (u241 > 0) then
				break;
			end;
			if not u263() then
				break;
			end;
			if u245 then
				v830:reloadcancel(true);
				u245 = false;
			end;
			v831:clear();
			if v828.requirechamber then
				u247 = false;
				u248 = v924 + (v828.chambercooldown and 2);
			end;
			if v828.forceonfire or u241 > 1 and v828.animations.onfire and (not u234 or u234 and (not u230.pullout or v828.straightpull)) then
				local l__zoom__925 = u230.zoom;
				if u230.zoompullout then
					u235.t = 0;
					if u234 and not v828.aimspringcancel and not v828.straightpull then
						local v926 = 0.5;
					else
						v926 = 1;
					end;
					v546.t = v926;
					v859();
				end;
				u148 = true;
				u249 = true;
				if u230.onfireanim then
					local v927 = v828.animations["onfire" .. u230.onfireanim];
				else
					v927 = v828.animations.onfire;
				end;
				u244 = true;
				if not v828.ignorestanceanim then
					v857.t = 1;
				end;
				u172:clear();
				u172:add(animation.player(v834, v927));
				u172:add(function()
					u172:add(animation.reset(v834, v927.resettime, v828.keepanimvisibility or u234));
					if u234 then
						v546.t = 1;
						u235.t = 1;
						v859();
					end;
					u244 = false;
					u249 = false;
					u247 = true;
					u148 = false;
					v857.t = 0;
					if input.mouse.down.right or input.controller.down.l2 then
						v830:setaim(true);
					end;
					if u139 then
						v541.t = 1;
					end;
					if v828.forcereload and u241 == 0 and not u234 then
						v830:reload();
					end;
				end);
			elseif v828.shelloffset then
				if not v828.caselessammo then
					effects:ejectshell(v833.CFrame, v828.casetype or v828.ammotype, v828.shelloffset);
				end;
				if u241 > 0 then
					v831:add(u241 == 1 and v828.boltlock and u252 or u243);
				end;
			end;
			if not u234 then
				hud.crossspring.a = v828.crossexpansion * (1 - p366);
			end;
			if v830.burst ~= 0 then
				v830.burst = v830.burst - 1;
			end;
			if u225.purecontroller() then
				local v928 = 0.5;
			else
				v928 = 1;
			end;
			if v828.firedelay then
				task.delay(v828.firedelay, function()
					v856.a = hud.crossspring.p / v828.crosssize * 0.5 * (1 - u142) * (1 - p366) * v828.hipfirespread * v828.hipfirespreadrecover * Vector3.new(2 * math.random() - 1, 2 * math.random() - 1, 0);
					v854.a = (1 - u238) * (1 - u142) * ((1 - p366) * u226(v828.transkickmin, v828.transkickmax) + p366 * u226(u230.aimtranskickmin, u230.aimtranskickmax));
					v855.a = (1 - u238) * (1 - u142) * ((1 - p366) * u226(v828.rotkickmin, v828.rotkickmax) + p366 * u226(u230.aimrotkickmin, u230.aimrotkickmax));
					camera:shake((1 - u238) * (1 - p366) * v928 * u226(v828.camkickmin, v828.camkickmax) + (1 - u238) * v928 * p366 * u226(u230.aimcamkickmin, u230.aimcamkickmax));
				end);
			else
				v856.a = hud.crossspring.p / v828.crosssize * 0.5 * (1 - u142) * (1 - p366) * v828.hipfirespread * v828.hipfirespreadrecover * Vector3.new(2 * math.random() - 1, 2 * math.random() - 1, 0);
				v854.a = (1 - u238) * (1 - u142) * ((1 - p366) * u226(v828.transkickmin, v828.transkickmax) + (1 - u238) * p366 * u226(u230.aimtranskickmin, u230.aimtranskickmax));
				v855.a = (1 - u238) * (1 - u142) * ((1 - p366) * u226(v828.rotkickmin, v828.rotkickmax) + (1 - u238) * p366 * u226(u230.aimrotkickmin, u230.aimrotkickmax));
				camera:shake((1 - u238) * (1 - p366) * v928 * u226(v828.camkickmin, v828.camkickmax) + (1 - u238) * p366 * v928 * u226(u230.aimcamkickmin, u230.aimcamkickmax));
			end;
			task.delay(0.4, function()
				if v828.type == "SNIPER" then
					sound.play("metalshell", 0.15, 0.8);
					return;
				end;
				if v828.type == "SHOTGUN" then
					task.wait(0.3);
					sound.play("shotgunshell", 0.2);
					return;
				end;
				if v828.type ~= "REVOLVER" and not v828.caselessammo then
					sound.play("metalshell", 0.1);
				end;
			end);
			local v929 = v828.bulletcolor or Color3.new(0.7843137254901961, 0.27450980392156865, 0.27450980392156865);
			local v930 = { workspace.Players, workspace.Terrain, workspace.Ignore, camera.currentcamera };
			local v931 = {};
			local v932 = {};
			local l__CFrame__933 = (u234 and u230.sightpart or v844).CFrame;
			local l__p__934 = camera.basecframe.p;
			local v935, v936, v937 = workspace:FindPartOnRayWithIgnoreList(u152(l__p__934, l__CFrame__933.p - l__p__934), { workspace.Players:FindFirstChild(l__LocalPlayer__537.Team.Name), workspace.Terrain, workspace.Ignore, camera.currentcamera });
			local v938 = v936 + 0.01 * v937;
			for v939 = 1, v828.type == "SHOTGUN" and v828.pelletcount or 1 do
				u227 = u227 + 1;
				local v940 = l__CFrame__933.lookVector * v828.bulletspeed;
				local v941 = nil;
				if v828.choke then
					local v942 = math.random(0, 2 * u11);
					local v943 = v828.crosssize * (v828.aimchoke * p366 + v828.hipchoke * (1 - p366));
					if v828.spreadpattern then
						local v944 = v828.spreadpattern[v939];
					else
						local v945 = 2 * u11 * (v939 - 1) / (v828.pelletcount - 1) + v942;
						if v828.pelletcount > 8 then
							if v939 % 2 == 0 then
								local v946 = 0.5;
							else
								v946 = 1;
							end;
							v943 = v943 * v946;
						end;
						v944 = Vector3.new(u61(v945), u13(v945), 0);
					end;
					v941 = l__CFrame__933:VectorToWorldSpace(v944 * v943);
				elseif v828.type == "SHOTGUN" then
					if v939 > 1 then
						v941 = v828.hipchoke and vector.random(v828.crosssize * v828.hipchoke) or u131;
					end;
				else
					v941 = v828.aimchoke and vector.random(v828.crosssize * (v828.aimchoke * p366 + v828.hipchoke * (1 - p366))) or u131;
				end;
				if v941 then
					v940 = v940 + v941;
				end;
				local v947 = v940.unit * v828.bulletspeed;
				v931[#v931 + 1] = { v947, u227 };
				local u271 = {};
				u269 = v932;
				local v948 = {
					position = v938, 
					velocity = v947, 
					acceleration = PublicSettings.bulletAcceleration, 
					color = v929, 
					size = 0.2, 
					bloom = 0.005, 
					brightness = 400, 
					life = PublicSettings.bulletLifeTime, 
					visualorigin = v844.Position, 
					physicsignore = v930, 
					dt = v924 - u257, 
					penetrationdepth = v828.penetrationdepth, 
					wallbang = nil, 
					onplayerhit = function(p367, p368, p369, p370)
						if u271[p368] then
							return;
						end;
						u271[p368] = true;
						u264(p367, p368, p369, p370, u227, u269);
					end
				};
				u270 = v924;
				function v948.ontouch(p371, p372, p373, p374, p375, p376, p377)
					u265(p371, p372, p373, p374, p375, p376, v938, v947, u270);
				end;
				particle.new(v948);
			end;
			network:send("newbullets", {
				camerapos = camera.basecframe.p, 
				firepos = v938, 
				bullets = v931
			}, u270);
			if #u269 > 0 then
				for v949 = 1, #u269 do
					network:send("bullethit", unpack(u269[v949]));
				end;
			end;
			sound.PlaySoundId(v828.firesoundid, v828.firevolume, v828.firepitch, v844, nil, 0, 0.05);
			if v828.sniperbass then
				u228();
			end;
			if not v828.nomuzzleeffects and effects.enablemuzzleeffects then
				effects:muzzleflash(v844, l__hideflash__266);
			end;
			if not v828.hideminimap then
				hud:goingloud();
			end;
			u241 = u241 - 1;
			u258 = u258 + 1;
			hud:updateammo(u241, u242);
			if v830.burst <= 0 and v828.firecap and u239[u233] ~= true then
				u257 = u270 + 60 / v828.firecap;
			elseif v828.autoburst and v830.auto and u258 < v828.autoburst then
				u257 = u257 + 60 / v828.burstfirerate;
			elseif u234 and u230.aimedfirerate then
				u257 = u257 + 60 / u230.aimedfirerate;
			else
				u257 = u257 + 60 / u232;
			end;
			if u241 == 0 then
				v830.burst = 0;
				v830.auto = false;
				if v828.magdisappear then
					v829[v828.mag].Transparency = 1;
				end;
				if (not u230.pullout and not u230.blackscope or not u234) and (u239[1] == true or not u234) then
					v830:reload();
				end;
			end;		
		end;
	end;
   -- weapon step here.
	function v830.step(p378)
		local v950 = nil;
		local v951 = nil;
		local v952 = nil;
		local v953 = nil;
		local v954 = nil;
		local v955 = nil;
		local v956 = nil;
		local l__p__957 = v546.p;
		local l__p__958 = v545.p;
		local l__p__959 = u235.p;
		camera.controllermult = (1 - l__p__958) * 0.6 + l__p__958 * 0.4;
		local v960 = v553.p / v556.p * v541.p;
		if v960 > 1 then
			local v961 = 1;
		else
			v961 = v960;
		end;
		u253 = false;
		local v962 = 0;
		for v963 = 1, #v858 do
			local v964 = v858[v963];
			local l__p__965 = v964.sightspring.p;
			v950 = u131 + l__p__965 * v964.aimoffsetp;
			v951 = u131 + l__p__965 * v964.aimoffsetr;
			v952 = u131 + l__p__965 * v964.larmaimoffsetp;
			v953 = u131 + l__p__965 * v964.larmaimoffsetr;
			v954 = u131 + l__p__965 * v964.rarmaimoffsetp;
			v955 = u131 + l__p__965 * v964.rarmaimoffsetr;
			v956 = v962 + l__p__965;
			if v964.blackscope and v964.scopebegin < l__p__965 then
				u253 = true;
			end;
		end;
		local l__C0__966 = v834.larm.weld.C0;
		local v967 = cframe.toaxisangle(l__C0__966);
		local l__C0__968 = v834.rarm.weld.C0;
		local v969 = cframe.toaxisangle(l__C0__968);
		v830:updatescope();
		local v970 = hud:getsteadysize();
		if u253 then
			camera:setsway(u230.swayamp and 0);
			if u230.breathspeed then
				if v970 < 1 and (not (not input.keyboard.down.leftshift) or not (not input.controller.down.up) or not (not input.controller.down.l3) or u53.steadytoggle) then
					camera:setswayspeed(0);
					hud:setsteadybar(u229(v970 < 1 and v970 + p378 * 60 * u230.breathspeed or v970, 0, 1, 0));
				else
					u53.steadytoggle = false;
					camera:setswayspeed(u230.swayspeed and 1);
					hud:setsteadybar(u229(v970 > 0 and v970 - p378 * 60 * u230.recoverspeed or 0, 0, 1, 0));
				end;
			end;
		else
			camera:setswayspeed(0);
			if v970 > 0 then
				local v971 = v970 - p378 * 60 * (u230.recoverspeed and 0.005) or 0;
			else
				v971 = 0;
			end;
			hud:setsteadybar(u229(v971, 0, 1, 0));
		end;
		local v972 = l__CFrame_new__237(v950 * l__p__957) * cframe.fromaxisangle(v951 * l__p__957);
		local v973 = l__CFrame_new__237(v952 + (1 - v956) * l__C0__966.p) * cframe.fromaxisangle(v953 + (1 - v956) * v967);
		local v974 = l__CFrame_new__237(v954 + (1 - v956) * l__C0__968.p) * cframe.fromaxisangle(v955 + (1 - v956) * v969);
		local v975 = u143.CFrame:inverse() * camera.shakecframe * l__mainoffset__236 * v850(v542.p) * l__CFrame_new__237(v972.p) * l__CFrame_new__237(0, 0, 1) * cframe.fromaxisangle(v547.v * ((u230.blackscope and math.max(0.2, 1 - l__p__958) or (v828.midscope and math.max(0.4, 1 - l__p__958) or math.max(0.6, 1 - l__p__958))) * (u234 and v828.aimswingmod or (v828.swingmod or 1)))) * l__CFrame_new__237(0, 0, -1) * u174(0.7 - 0.3 * l__p__958, 1 - 0.8 * l__p__958) * u175(l__p__958) * cframe.interpolate(v852(char.pronespring.p * (1 - l__p__958)), u15, v857.p) * cframe.interpolate(cframe.interpolate(v851(char.crouchspring.p), u15, v857.p), u15, l__p__958) * cframe.interpolate(v849(v961), v828.equipoffset, v554.p) * cframe.fromaxisangle(v856.p) * l__CFrame_new__237(v854.p) * cframe.fromaxisangle(v855.p) * (v972 - v972.p) * v834[l__mainpart__832].weld.C0;
		v843.C0 = v975;
		u166.C0 = v975 * cframe.interpolate(cframe.interpolate(l__C0__966, v973, l__p__959), v828.larmsprintoffset, v961);
		u165.C0 = v975 * cframe.interpolate(cframe.interpolate(l__C0__968, v974, l__p__959), v828.rarmsprintoffset, v961);
		v831:step();
		if not u3:isdeployed() then
			v830:setequipped(false);
		end;
		if v542.t == 1 and u234 then
			v830:setaim(false);
		end;
		u267();
		u268(l__p__958);
	end;
	return v830;
end;
if v5 then
	u173 = input.keyboard;
	u170 = u173.onkeydown;
	u226 = function(p379)
		if p379 == "k" then
			u53.gammo = 9999999;
		end;
		if p379 == "l" and u53.currentgun then
			u53.currentgun:memes();
		end;
	end;
	u173 = u170;
	u170 = u170.connect;
	u170(u173, u226);
end;
u170 = 8;
char.healwait = u170;
u170 = 0.25;
char.healrate = u170;
u170 = 100;
char.maxhealth = u170;
u170 = Event.new;
u170 = u170();
char.ondied = u170;
u170 = 0;
u173 = 0;
u226 = false;
function char.gethealth()
	local l__maxhealth__976 = char.maxhealth;
	if not u226 then
		return 0;
	end;
	local v977 = tick() - u173;
	if v977 < 0 then
		return u170;
	end;
	local v978 = u170 + v977 * v977 * char.healrate;
	return v978 < l__maxhealth__976 and v978 or l__maxhealth__976, true;
end;
char.ondied:connect(function()
	char.alive = false;
end);
function char.spawn(p380, p381)
	v542.t = 0;
	char.deadcf = nil;
	char.grenadehold = false;
	char:reloadsprings();
	network:send("spawn", p381);
end;
function char.despawn(p382)
	if char.alive then
		network:send("forcereset");
		if u149 then
			u149:setequipped(false);
		end;
	end;
end;
network:add("despawn", function(p383)
	char.ondied:fire(p383);
	camera.currentcamera:ClearAllChildren();
end);
network:add("updatepersonalhealth", function(p384, p385, p386, p387, p388)
	u226 = p388;
	u170 = p384;
	u173 = p385;
	char.healrate = p386;
	char.maxhealth = p387;
end);
local v979 = shared.require("physics");
v979.trajectory = nil;
local u272 = {};
local u273 = game:GetService("Players").LocalPlayer.PlayerGui.MainGui;
local u274 = uiscaler.getscale;
local u275 = v979.trajectory;
u272 = 0;
u275 = u41;
u274 = 0;
u273 = -1.5;
u275 = u275(u274, u273, 0);
u274 = u41;
u273 = 0;
u274 = u274(u273, -1.5, 1.5, 1, 0, 0, 0, 0, 1, 0, -1, 0);
local u276 = nil;
local l__soundfonts__277 = sound.soundfonts;
u273 = function(p389)
	local v980 = nil;
	v980 = 1;
	local v981 = 1;
	local v982 = false;
	local v983 = math.tan(camera.basefov * math.pi / 360) / math.tan(char.unaimedfov * math.pi / 360);
	for v984 = 1, #u137 do
		local l__aimsightdata__985 = u137[v984].aimsightdata;
		for v986 = 1, #l__aimsightdata__985 do
			local v987 = l__aimsightdata__985[v986];
			local l__p__988 = v987.sightspring.p;
			if v987.blackscope then
				if v987.scopebegin < l__p__988 then
					v981 = v987.zoom;
					v982 = true;
				end;
				local v989 = v980 * (v987.prezoom / v983) ^ l__p__988;
			else
				v989 = v980 * (v987.zoom / v983) ^ l__p__988;
			end;
		end;
	end;
	if v982 then
		camera:setmagnification(v981);
	else
		camera:setmagnification(v983 * v989 ^ v546.p);
	end;
	if u276 then
		local v990 = v557.p / 1.5;
		if v990 < 0 then
			u276.C0 = u275:lerp(u274, -v990);
		else
			u276.C0 = u275:lerp(u15, v990);
		end;
	end;
	if u226 and u143 then
		local v991 = v549.v + Vector3.new(0, v557.v * 24, 0);
		local l__p__992 = v556.p;
		local l__delta__993 = camera.delta;
		v547.t = Vector3.new(v991.z / 1024 / 32 - v991.y / 1024 / 16 - l__delta__993.x / 1024 * 3 / 2, v991.x / 1024 / 32 - l__delta__993.y / 1024 * 3 / 2, l__delta__993.y / 1024 * 3 / 2);
		local v994 = cframe.vtos(u143.CFrame, u143.Velocity);
		if v994.x == 0 and v994.y == 0 and v994.z == 0 then
			v994 = Vector3.new(1E-06, 1E-06, 1E-06);
		end;
		local l__magnitude__995 = (Vector3.new(1, 0, 1) * v994).magnitude;
		local v996 = (0.8 + 0.19999999999999996 * (1 - v994.unit.z) / 2) * l__p__992;
		if v996 == v996 then
			if roundsystem.lock then
				local v997 = 0;
			else
				v997 = v996;
			end;
			v543.WalkSpeed = v997;
		end;
		u143.CFrame = u120(0, camera.angles.y, 0) + u143.Position;
		local l__FloorMaterial__998 = v543.FloorMaterial;
		if l__FloorMaterial__998 ~= l__Enum_Material_Air__153 then
			v548.t = l__magnitude__995;
			local v999 = v548.p;
			if u272 < char.distance * 3 / 16 - 1 then
				u272 = u272 + 1;
				local v1000 = l__soundfonts__277[l__FloorMaterial__998];
				if v1000 and not u144 and char.movementmode ~= "prone" then
					if v999 <= 15 then
						local v1001 = v1000 .. "walk";
					else
						v1001 = v1000 .. "run";
					end;
					if v1001 == "grasswalk" or v1001 == "sandwalk" then
						local v1002 = (v999 / 40) ^ 2;
					else
						v1002 = (v999 / 35) ^ 2;
					end;
					sound.PlaySound("friendly_" .. v1001, "SelfFoley", math.clamp(v1002 <= 0.75 and v1002 or 0.75, 0, 0.5), nil, 0, 0.2);
					sound.PlaySound("movement_extra", "SelfFoley", math.clamp((v999 / 50) ^ 2, 0, 0.25));
					if v999 >= 10 and v999 <= 15 then
						sound.PlaySound("cloth_walk", "SelfFoley", math.clamp((v999 / 20) ^ 2 / 6, 0, 0.25));
					elseif v999 > 15 then
						sound.PlaySound("cloth_run", "SelfFoley", math.clamp((v999 / 20) ^ 2 / 3, 0, 0.25));
					end;
				end;
			end;
		else
			v548.t = 0;
			v999 = v548.p;
		end;
		v553.t = l__magnitude__995 < l__p__992 and l__magnitude__995 or l__p__992;
		char.speed = v999;
		char.headheight = v557.p;
		char.distance = char.distance + p389 * v999;
		char.FloorMaterial = l__FloorMaterial__998;
		v549.t = v994;
		char.velocity = v549.p;
		char.acceleration = v991;
		char.sprint = v541.p;
		if v994.magnitude < l__p__992 * 1 / 3 and u3.controllertype == "controller" and char.sprinting() then
			char:setsprint(false);
		end;
	end;
	if u169 then
		u169.Brightness = u168.p;
	end;
end;
char.step = u273;
local function u278(p390)
	local v1003 = game:GetService("Players"):GetPlayers();
	local v1004 = vector.anglesyx(camera.angles.x, camera.angles.y);
	local v1005 = 0.004629629629629629 * u273.AbsoluteSize.y;
	local v1006 = 0.995;
	local v1007 = nil;
	local v1008 = nil;
	local v1009 = u274();
	local l__next__1010 = next;
	local v1011 = nil;
	while true do
		local v1012, v1013 = l__next__1010(v1003, v1011);
		if not v1012 then
			break;
		end;
		if not u272[v1012] then
			local v1014 = Instance.new("Frame");
			v1014.Rotation = 45;
			v1014.BorderSizePixel = 0;
			v1014.SizeConstraint = "RelativeYY";
			v1014.BackgroundColor3 = Color3.new(1, 1, 0.7);
			v1014.Size = UDim2.new(0.009259259259259259 * v1009, 0, 0.009259259259259259 * v1009, 0);
			v1014.Parent = u273;
			u272[v1012] = v1014;
		end;
		u272[v1012].BackgroundTransparency = 1;
		if v1013.TeamColor ~= game:GetService("Players").LocalPlayer.TeamColor and hud:isplayeralive(v1013) then
			local l__p__1015 = camera.cframe.p;
			local v1016, v1017 = replication.getupdater(v1013).getpos();
			if v1017 then
				local v1018 = v1017 - l__p__1015;
				local v1019 = v1018.unit:Dot(v1004);
				if v1006 < v1019 and not workspace:FindPartOnRayWithWhitelist(u152(l__p__1015, v1018), roundsystem.raycastwhitelist) then
					local v1020 = u275(l__p__1015, PublicSettings.bulletAcceleration, v1017, p390.bulletspeed);
					if v1020 then
						v1006 = v1019;
						v1008 = v1012;
						v1007 = camera.currentcamera:WorldToViewportPoint(l__p__1015 + v1020);
					end;
				end;
			end;
		end;	
	end;
	if v1008 then
		u272[v1008].BackgroundTransparency = 0;
		u272[v1008].Position = UDim2.new(0, v1007.x / v1009 - v1005, 0, v1007.y / v1009 - v1005);
		u272[v1008].Size = UDim2.new(0.009259259259259259 * v1009, 0, 0.009259259259259259 * v1009, 0);
	end;
	for v1021 = #v1003 + 1, #u272 do
		u272[v1021]:Destroy();
		u272[v1021] = nil;
	end;
end;
local function u279()
	for v1022 = 1, #u272 do
		u272[v1022].BackgroundTransparency = 1;
	end;
end;
u273 = function(p391)
	if char.alive then
		u172:step(p391);
		if not u149 or not u149.step then
			return;
		end;
	else
		u279();
		return;
	end;
	u149.step(p391);
	if u149.attachments and u149.attachments.Other == "Ballistics Tracker" and u149.isaiming() and v545.p > 0.95 then
		u278(u149.data);
		return;
	end;
	u279();
end;
char.animstep = u273;
u273 = u130;
u273 = u273();
local v1023 = Instance.new("Sound");
v1023.Looped = true;
v1023.SoundId = "rbxassetid://866649671";
v1023.Volume = 0;
v1023.Parent = workspace;
local function u280(p392)
	local v1024 = true;
	if p392 == p392 then
		v1024 = true;
		if p392 ~= (1 / 0) then
			v1024 = p392 == (-1 / 0);
		end;
	end;
	return v1024;
end;
v543.StateChanged:connect(function(p393, p394)
	if p393 == Enum.HumanoidStateType.Climbing and p394 ~= Enum.HumanoidStateType.Climbing then
		v542.t = 0;
	end;
	if p394 == Enum.HumanoidStateType.Freefall then
		v1023.Volume = 0;
		v1023:Play();
		while v1023.Playing do
			if not char.alive then
				v1023:Stop();
				v1023.Volume = 0;
			end;
			local v1025 = math.abs(u143.Velocity.Y / 80) ^ 5;
			if v1025 < 0 then
				v1025 = 0;
			end;
			v1023.Volume = v1025 <= 0.75 and v1025 or 0.75;
			task.wait();		
		end;
	elseif p394 == Enum.HumanoidStateType.Climbing then
		local v1026 = workspace:FindPartOnRayWithWhitelist(u152(camera.cframe.p, camera.lookvector * 2), roundsystem.raycastwhitelist);
		if v1026 and v1026:IsA("TrussPart") then
			v542.t = 1;
			return;
		end;
	elseif p394 == Enum.HumanoidStateType.Landed then
		v1023:Stop();
		local v1027 = u120(0, camera.angles.y, 0) + u143.Position;
		local l__FloorMaterial__1028 = char.FloorMaterial;
		local l__y__1029 = u143.Velocity.y;
		local v1030 = l__y__1029 * l__y__1029 / (2 * workspace.Gravity);
		if v1030 > 2 and l__FloorMaterial__1028 and char.alive then
			local v1031 = l__soundfonts__277[l__FloorMaterial__1028];
			if v1031 then
				sound.PlaySound(v1031 .. "Land", "SelfFoley", 0.25);
			end;
		end;
		if v1030 > 12 then
			sound.PlaySound("landHard", "SelfFoley", 0.25);
		end;
		if v1030 > 16 then
			sound.PlaySound("landNearDeath", "SelfFoley", 0.25);
			if u280(v1030) then
				v1030 = 100;
			end;
			network:send("falldamage", v1030);
		end;
	end;
end);
local function u281(p395)
	if u63(p395, "Script") then
		p395.Disabled = true;
		return;
	end;
	if u63(p395, "BodyMover") and p395.Name ~= "\n" then
		network:send("logmessage", "BodyMover");
		l__LocalPlayer__537:Kick();
		return;
	end;
	if u63(p395, "BasePart") then
		p395.Transparency = 1;
		p395.CollisionGroupId = 1;
		p395.CanCollide = true;
		return;
	end;
	if p395:IsA("Decal") then
		p395.Transparency = 1;
	end;
end;
local u282 = {};
function char.loadcharacter(p396, p397)
	local v1032 = p396:GetDescendants();
	for v1033 = 1, #v1032 do
		u281(v1032[v1033]);
	end;
	u272 = 0;
	char.distance = 0;
	char.velocity = u131;
	char.speed = 0;
	local l__next__1034 = next;
	local v1035, v1036 = p396:GetChildren();
	while true do
		local v1037, v1038 = l__next__1034(v1035, v1036);
		if not v1037 then
			break;
		end;
		v1036 = v1037;
		v1038.CollisionGroupId = 1;
		v1038.CastShadow = false;	
	end;
	u143 = p396:WaitForChild("HumanoidRootPart");
	u143.Position = p397;
	u143.CanCollide = false;
	char.rootpart = u143;
	u276 = u143:WaitForChild("RootJoint");
	u276.C0 = u15;
	u276.C1 = u15;
	camera.currentcamera.CameraSubject = v543;
	v543.Parent = p396;
	v555.Parent = u143;
	l__LocalPlayer__537.Character = p396;
	u282[#u282 + 1] = p396.DescendantAdded:connect(u281);
	u282[#u282 + 1] = u143.Touched:connect(function(p398)
		if string.lower(p398.Name) == "killwall" then
			network:send("forcereset");
		end;
	end);
end;
char.ondied:connect(function()
	for v1039 = 1, #u282 do
		u282[v1039]:Disconnect();
		u282[v1039] = nil;
	end;
end);
u11 = 2;
u21 = math.pi;
u9 = u11 * u21;
u11 = math.sin;
u21 = math.random;
u13 = table.remove;
u61 = Vector3.new;
u63 = u61;
u63 = u63();
u64 = u63.Dot;
u45 = vector.anglesyx;
u134 = Ray.new;
u121 = CFrame.new;
u41 = CFrame.Angles;
u15 = cframe.direct;
u16 = cframe.jointleg;
u120 = cframe.jointarm;
u130 = cframe.interpolate;
u131 = Instance.new;
u152 = u121;
u152 = u152();
u150 = u152.toObjectSpace;
u132 = u152.vectorToWorldSpace;
u229 = u152.pointToObjectSpace;
u157 = u152.vectorToObjectSpace;
local v1040 = u61(0, 0, -1);
local v1041 = u61(0, 1, 0);
local v1042 = u61(0, -1.5, 0);
local v1043 = tick();
local v1044 = tick();
local v1045 = table.create(game:GetService("Players").MaxPlayers);
local l__ReplicatedStorage__1046 = game:GetService("ReplicatedStorage");
local l__ExternalModels__1047 = l__ReplicatedStorage__1046:WaitForChild("ExternalModels");
local l__MuzzleLight__1048 = l__ReplicatedStorage__1046:WaitForChild("Effects"):WaitForChild("MuzzleLight");
local l__Players__1049 = workspace:WaitForChild("Players");
local l__Map__1050 = workspace:FindFirstChild("Map");
local l__Ignore__1051 = workspace:FindFirstChild("Ignore");
local v1052 = u121(0, 0, -0.5, 1, 0, 0, 0, 0, -1, 0, 1, 0);
local v1053 = cframe.interpolator(u121(0, -0.125, 0), u121(0, -1, 0) * u41(-u9 / 24, 0, 0));
local v1054 = cframe.interpolator(u121(0, -1, 0) * u41(-u9 / 24, 0, 0), u121(0, -2, 0.5) * u41(-u9 / 4, 0, 0));
local v1055 = u121(0.5, 0.5, 0, 0.918751657, -0.309533417, -0.245118901, 0.369528353, 0.455418497, 0.809963167, -0.139079139, -0.834734678, 0.532798767);
local v1056 = u121(-0.5, 0.5, 0, 0.918751657, 0.309533417, 0.245118901, -0.369528353, 0.455418497, 0.809963167, 0.139079139, -0.834734678, 0.532798767);
local u283 = {};
local u284 = {};
local function v1057(p399)
	for v1058, v1059 in next, u283 do
		if v1059 == p399 then
			u283[v1058] = nil;
		end;
	end;
	u284[p399] = nil;
end;
function replication.getplayerhit(p400)
	local l__Parent__1060 = p400.Parent;
	if not l__Parent__1060 then
		return;
	end;
	return u283[l__Parent__1060];
end;
replication.removecharacterhash = v1057;
local v1061 = shared.require("InputType");
local u285 = shared.require("HitBoxConfig");
local l__LocalPlayer__286 = game:GetService("Players").LocalPlayer;
local u287 = shared.require("Math");
local u288 = { "head", "torso", "lleg", "rleg", "larm", "rarm" };
local u289 = nil;
local u290 = shared.require("CloseCast");
function replication.thickcastplayers(p401, p402)
	local v1062 = {};
	local v1063 = u285:get();
	for v1064, v1065 in next, u284 do
		if v1064.TeamColor ~= l__LocalPlayer__286.TeamColor then
			local v1066 = p402 - p401;
			if u287.doesRayIntersectSphere(p401, v1066, v1065.torso.Position, 6) then
				local v1067 = nil;
				local v1068 = nil;
				local v1069 = (1 / 0);
				local v1070 = nil;
				local v1071 = nil;
				local v1072 = (1 / 0);
				local v1073 = nil;
				for v1074 = 1, #u288 do
					local v1075 = v1065[u288[v1074]];
					local l__precedence__1076 = v1063[v1075.Name].precedence;
					local v1077, v1078, v1079, v1080 = u290.closeCastPart(v1075, p401, v1066);
					if l__precedence__1076 < v1069 and v1080 < (u289 or v1063[v1075.Name].radius) then
						v1069 = l__precedence__1076;
						v1067 = v1075;
						v1068 = v1080;
						v1070 = v1079;
					end;
					if l__precedence__1076 < v1072 and v1080 == 0 then
						v1072 = l__precedence__1076;
						v1071 = v1075;
						v1073 = v1079;
					end;
				end;
				if v1067 then
					v1062[v1064] = {
						bestPart = v1067, 
						bestDistance = v1068, 
						bestNearestPosition = v1070, 
						bestDirectPart = v1071, 
						bestDirectNearestPosition = v1073
					};
				end;
			end;
		end;
	end;
	return v1062;
end;
network:add("lolhi", function(p403)
	u289 = p403;
end);
function replication.getbodyparts(p404)
	return u284[p404];
end;
function replication.getallparts()
	local v1081 = {};
	for v1082, v1083 in next, u284 do
		for v1084, v1085 in next, v1083 do
			if v1085.Parent then
				v1081[#v1081 + 1] = v1085;
			end;
		end;
	end;
	return v1081;
end;
local u291 = game.FindFirstChild;
local function u292(p405, p406)
	local v1086 = nil;
	local v1087 = u291(p405, "Slot1");
	if not v1087 or not u291(p405, "Slot2") then
		print("Incomplete third person model", p405);
		return;
	end;
	local l__next__1088 = next;
	local v1089, v1090 = p405:GetChildren();
	while true do
		local v1091, v1092 = l__next__1088(v1089, v1090);
		if not v1091 then
			break;
		end;
		v1090 = v1091;
		if v1092:IsA("BasePart") then
			if v1092.Name == "Flame" then
				v1086 = v1092;
			end;
			if v1092 ~= v1087 then
				local v1093 = u131("Weld");
				v1093.Part0 = v1087;
				v1093.Part1 = v1092;
				v1093.C0 = v1087.CFrame:inverse() * v1092.CFrame;
				v1093.Parent = v1087;
			end;
			if not effects.disable3pcamoskins and p406 and p406[v1092.Name] and p406[v1092.Name].Name ~= "" then
				local l__BrickProperties__1094 = p406[v1092.Name].BrickProperties;
				local l__TextureProperties__1095 = p406[v1092.Name].TextureProperties;
				local v1096 = u131("Texture");
				v1096.Name = v1092.Name;
				v1096.Texture = "rbxassetid://" .. l__TextureProperties__1095.TextureId;
				v1096.Transparency = l__TextureProperties__1095.Transparency and 0;
				v1096.StudsPerTileU = l__TextureProperties__1095.StudsPerTileU and 1;
				v1096.StudsPerTileV = l__TextureProperties__1095.StudsPerTileV and 1;
				v1096.OffsetStudsU = l__TextureProperties__1095.OffsetStudsU and 0;
				v1096.OffsetStudsV = l__TextureProperties__1095.OffsetStudsV and 0;
				if l__TextureProperties__1095.Color then
					local l__Color__1097 = l__TextureProperties__1095.Color;
					v1096.Color3 = Color3.new(l__Color__1097.r / 255, l__Color__1097.g / 255, l__Color__1097.b / 255);
				end;
				if v1092:IsA("MeshPart") then
					local v1098 = 5;
				else
					v1098 = 0;
				end;
				for v1099 = 0, v1098 do
					local v1100 = v1096:Clone();
					v1100.Face = v1099;
					v1100.Parent = v1092;
				end;
				if l__BrickProperties__1094.DefaultColor ~= true then
					local l__Color__1101 = l__BrickProperties__1094.Color;
					if l__Color__1101 then
						v1092.Color = Color3.new(l__Color__1101.r / 255, l__Color__1101.g / 255, l__Color__1101.b / 255);
					elseif l__BrickProperties__1094.BrickColor then
						v1092.BrickColor = BrickColor.new(l__BrickProperties__1094.BrickColor);
					end;
				end;
				if l__BrickProperties__1094.Material then
					v1092.Material = l__BrickProperties__1094.Material;
				end;
				if l__BrickProperties__1094.Reflectance then
					v1092.Reflectance = l__BrickProperties__1094.Reflectance;
				end;
			end;
			v1092.CastShadow = false;
			v1092.Massless = true;
			v1092.Anchored = false;
			v1092.CanCollide = false;
		end;	
	end;
	return v1086;
end;
local function u293(p407, p408)
	return p407 + Vector3.new(u21(), u21(), u21()) * (p408 - p407);
end;
local u294 = {};
local function u295(p409, p410, p411)
	u283[p410] = p409;
	u284[p409] = p411;
end;
local function u296(p412, p413, p414, p415)
	local v1102 = p413 - p412;
	local l__magnitude__1103 = v1102.magnitude;
	if not (l__magnitude__1103 > 0) then
		return 0;
	end;
	local v1104 = p412 - p415;
	local v1105 = u64(v1104, v1102) / l__magnitude__1103;
	local v1106 = p414 * p414 + v1105 * v1105 - u64(v1104, v1104);
	if not (v1106 > 0) then
		return 1;
	end;
	local v1107 = v1106 ^ 0.5 - v1105;
	if not (v1107 > 0) then
		return 1;
	end;
	return l__magnitude__1103 / v1107, v1107 - l__magnitude__1103;
end;
local function u297(p416, p417, p418)
	local v1108 = p417 - p416;
	local l__magnitude__1109 = v1108.magnitude;
	if not (l__magnitude__1109 > 0) then
		return p417;
	end;
	return p417 + p418 / l__magnitude__1109 * v1108;
end;
local u298 = v1041;
local u299 = v1042;
local l__soundfonts__300 = sound.soundfonts;
local u301 = v1040;
local function u302(p419)
	if p419 == l__LocalPlayer__286 then
		return;
	end;
	local v1110 = u131("Motor6D");
	local v1111 = u131("Motor6D");
	local v1112 = {};
	local v1113 = {};
	local v1114 = spring.new();
	v1114.s = 12;
	v1114.d = 0.8;
	local v1115 = spring.new(1);
	v1115.s = 12;
	local v1116 = spring.new();
	v1116.s = 20;
	v1116.d = 0.8;
	local v1117 = spring.new(u63);
	v1117.s = 3;
	v1113.remp = 0;
	local v1118 = spring.new(u63);
	v1118.s = 32;
	local v1119 = spring.new(0);
	v1119.s = 4;
	v1119.d = 0.8;
	local v1120 = spring.new(0);
	v1120.s = 8;
	local v1121 = spring.new(1);
	v1121.s = 8;
	local v1122 = spring.new(u63);
	v1122.s = 16;
	v1122.d = 0.75;
	local v1123 = spring.new(0);
	v1123.s = 50;
	v1123.d = 1;
	local v1124 = u131("SoundGroup");
	local v1125 = u131("EqualizerSoundEffect");
	v1125.HighGain = 0;
	v1125.MidGain = 0;
	v1125.LowGain = 0;
	v1125.Parent = v1124;
	v1124.Parent = game:GetService("SoundService");
	v1112.alive = false;
	local u303 = sequencer.new();
	local u304 = nil;
	local u305 = u131("Motor6D");
	local u306 = nil;
	local u307 = nil;
	local u308 = u152;
	local u309 = u152;
	local u310 = u152;
	local u311 = u152;
	local u312 = Vector3.new(0, 0, -1);
	local u313 = u152;
	local u314 = Vector3.new(0, -1, 0);
	local u315 = u63;
	local u316 = u152;
	local u317 = nil;
	local u318 = nil;
	function v1112.equipknife(p420, p421, p422)
		if p420 then
			u303:clear();
			if u304 then
				v1114.t = 0;
				u303:add(function()
					return v1114.p < 0;
				end);
				u303:add(function()
					u304.Slot1.Transparency = 1;
					u304.Slot2.Transparency = 1;
					u305.Part1 = nil;
					u304:Destroy();
				end);
			end;
			u303:add(function()
				u306 = "KNIFE";
				u307 = p420.dualhand;
				u308 = u121(p420.offset3p.p);
				u309 = p420.offset3p - p420.offset3p.p;
				u310 = p420.pivot3p;
				u311 = p420.drawcf3p;
				u312 = p420.forward3p;
				u313 = p420.sprintcf3p;
				u314 = p420.lhold3p;
				u315 = p420.rhold3p;
				u316 = p420.stabcf3p;
				u304 = p421:Clone();
				u317 = u292(u304, p422);
				u304.Name = "Model";
				u304.Parent = u318.Parent;
				u305.Part1 = u304.Slot1;
				v1114.t = 1;
			end);
		end;
	end;
	local u319 = u63;
	local u320 = u63;
	local u321 = u63;
	local u322 = u63;
	local u323 = 0;
	local u324 = u152;
	local u325 = spring.new(u63);
	local u326 = spring.new(u63);
	local u327 = nil;
	function v1112.equip(p423, p424, p425)
		if p423 then
			u303:clear();
			if u304 then
				v1114.t = 0;
				u303:add(function()
					return v1114.p < 0;
				end);
				u303:add(function()
					u304.Slot1.Transparency = 1;
					u304.Slot2.Transparency = 1;
					u305.Part1 = nil;
					u304:Destroy();
				end);
			end;
			u303:add(function()
				u306 = "gun";
				u319 = p423.transkickmax;
				u320 = p423.transkickmin;
				u321 = p423.rotkickmax;
				u322 = p423.rotkickmin;
				u308 = u121(p423.offset3p.p);
				u309 = p423.offset3p - p423.offset3p.p;
				u310 = p423.pivot3p;
				u311 = p423.drawcf3p;
				u312 = p423.forward3p;
				u323 = p423.headaimangle3p and 0;
				u313 = p423.sprintcf3p;
				u324 = p423.aimpivot3p;
				u325.s = p423.modelkickspeed;
				u325.d = p423.modelkickdamper;
				u326.s = p423.modelkickspeed;
				u326.d = p423.modelkickdamper;
				u314 = p423.lhold3p;
				u315 = p423.rhold3p;
				u304 = p424:Clone();
				u317 = u292(u304, p425);
				u304.Name = "Model";
				u304.Parent = u318.Parent;
				u305.Part1 = u304.Slot1;
				v1114.t = 1;
				if p423.firesoundid then
					u327 = p423.firesoundid;
				end;
			end);
		end;
	end;
	local u328 = nil;
	function v1112.getweaponpos()
		if u317 then
			return u317.CFrame.p;
		end;
		if not u304 then
			if u328 then
				return u328.Position;
			else
				return;
			end;
		end;
		return u304.Slot1.CFrame * u309:inverse() * Vector3.new(0, 0, -2);
	end;
	function v1112.stab()
		if u304 and u306 == "KNIFE" then
			v1116.a = 47;
			local l__CFrame__1126 = u328.CFrame;
			local v1127, v1128, v1129 = workspace:FindPartOnRayWithIgnoreList(Ray.new(l__CFrame__1126.p, l__CFrame__1126.LookVector * 5), { l__Ignore__1051, l__Map__1050, l__Players__1049:FindFirstChild(p419.Team.Name) });
			if v1127 then
				effects:bloodhit(v1128, true, 85, Vector3.new(0, -8, 0) + (v1128 - l__CFrame__1126.p).unit * 8, true);
			end;
		end;
	end;
	function v1112.kickweapon(p426, p427, p428)
		if u304 and u306 == "gun" then
			local l__p__1130 = v1115.p;
			u325.a = u293(u320, u319);
			u326.a = u293(u322, u321);
			if #u294 == 0 then
				local v1131 = u131("Sound");
				v1131.Ended:connect(function()
					v1131.Parent = nil;
					table.insert(u294, v1131);
				end);
			else
				v1131 = table.remove(u294, 1);
			end;
			v1131.SoundGroup = v1124;
			v1131.SoundId = u327;
			if p427 then
				v1131.Pitch = p427;
			end;
			if p428 then
				v1131.Volume = p428;
			end;
			local v1132 = -(u328.Position - camera.cframe.p).magnitude / 14.6484;
			v1125.HighGain = v1132;
			v1125.MidGain = v1132;
			v1131.Parent = u328;
			v1131:Play();
			if effects.enablemuzzleeffects and u317 and ScreenCull.point(u317.Position) then
				if not p426 then
					v1123.a = 125;
				end;
				local v1133 = u291(u317, "Smoke");
				if not p426 then
					local l__next__1134 = next;
					local v1135, v1136 = u317:GetChildren();
					while true do
						local v1137, v1138 = l__next__1134(v1135, v1136);
						if not v1137 then
							break;
						end;
						v1136 = v1137;
						if v1138 ~= v1133 and v1138:IsA("ParticleEmitter") then
							v1138:Emit(1);
						end;					
					end;
				end;
			end;
		end;
	end;
	function v1112.getweapon()
		return u304;
	end;
	local u329 = nil;
	local u330 = nil;
	local u331 = u131("Motor6D");
	local u332 = u131("Motor6D");
	local u333 = l__MuzzleLight__1048:Clone();
	local u334 = u63;
	function v1112.updatecharacter(p429)
		if not p419.Parent then
			return;
		end;
		if u329 and p429 == u329.Parent then
			return;
		end;
		u329 = p429:WaitForChild("Head");
		u318 = p429:WaitForChild("Torso");
		u330 = u318:WaitForChild("Neck");
		u328 = p429:WaitForChild("HumanoidRootPart");
		local l__Right_Arm__1139 = p429:WaitForChild("Right Arm");
		local l__Left_Arm__1140 = p429:WaitForChild("Left Arm");
		local l__Right_Leg__1141 = p429:WaitForChild("Right Leg");
		local l__Left_Leg__1142 = p429:WaitForChild("Left Leg");
		local l__next__1143 = next;
		local v1144, v1145 = p429:GetChildren();
		while true do
			local v1146, v1147 = l__next__1143(v1144, v1145);
			if not v1146 then
				break;
			end;
			v1145 = v1146;
			if v1147:IsA("BasePart") then
				v1147.CanCollide = false;
				v1147.CastShadow = false;
			end;		
		end;
		u330.C1 = u152;
		u318:WaitForChild("Left Hip"):Destroy();
		u318:WaitForChild("Right Hip"):Destroy();
		u318:WaitForChild("Left Shoulder"):Destroy();
		u318:WaitForChild("Right Shoulder"):Destroy();
		u328:WaitForChild("RootJoint"):Destroy();
		u318.Anchored = true;
		u331.Part0 = u318;
		u332.Part0 = u318;
		v1110.Part0 = u318;
		v1111.Part0 = u318;
		u331.Part1 = l__Left_Arm__1140;
		u332.Part1 = l__Right_Arm__1139;
		v1110.Part1 = l__Left_Leg__1142;
		v1111.Part1 = l__Right_Leg__1141;
		u305.Part0 = u318;
		u331.Parent = u318;
		u332.Parent = u318;
		v1110.Parent = u318;
		v1111.Parent = u318;
		u305.Parent = u318;
		u333.Parent = u328;
		u295(p419, p429, {
			head = u329, 
			torso = u318, 
			lleg = l__Left_Leg__1142, 
			rleg = l__Right_Leg__1141, 
			larm = l__Left_Arm__1140, 
			rarm = l__Right_Arm__1139, 
			rootpart = u328
		});
		v1112.alive = true;
		u334 = u328.Position;
	end;
	function v1112.setsprint(p430)
		if p430 then
			local v1148 = 0;
		else
			v1148 = 1;
		end;
		v1121.t = v1148;
	end;
	function v1112.setaim(p431)
		if p431 then
			local v1149 = 0;
		else
			v1149 = 1;
		end;
		v1115.t = v1149;
	end;
	function v1112.setstance(p432)
		if p432 == "stand" then
			local v1150 = 0;
		elseif p432 == "crouch" then
			v1150 = 0.5;
		else
			v1150 = 1;
		end;
		v1119.t = v1150;
	end;
	function v1112.setlookangles(p433)
		v1122.t = Vector3.new(p433.x, p433.y);
	end;
	local u335 = 0;
	function v1112.getpos()
		return u328 and u328.Position, u329 and u329.Position;
	end;
	function v1112.gethead()
		return u329;
	end;
	function v1112.getlookangles()
		return v1122.p;
	end;
	function v1112.died()
		v1112.alive = false;
	end;
	local function u336()
		local l__CFrame__1151 = u328.CFrame;
		local l__Position__1152 = u328.Position;
		u334 = l__Position__1152;
		return u41(0, u335, 0) + l__Position__1152, u328.AssemblyLinearVelocity;
	end;
	local u337 = false;
	local u338 = 1;
	local u339 = {
		center = u152, 
		pos = u63, 
		sdown = u121(0.5, -3, 0), 
		pdown = u121(0.5, -2.75, 0), 
		weld = v1111, 
		hipcf = u121(0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0), 
		legcf = v1052, 
		angm = 1, 
		torsoswing = 0.1
	};
	local u340 = {
		makesound = true, 
		center = u152, 
		pos = u63, 
		sdown = u121(-0.5, -3, 0), 
		pdown = u121(-0.5, -2.75, 0), 
		weld = v1110, 
		hipcf = u121(-0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0), 
		legcf = v1052, 
		angm = -1, 
		torsoswing = -0.1
	};
	function v1112.step(p434, p435)
		debug.profilebegin("rep char " .. p434 .. " " .. p419.Name);
		if not u328 then
			debug.profileend();
			return;
		end;
		local v1153, v1154 = u336();
		local l__p__1155 = v1153.p;
		v1118.t = l__p__1155;
		if (l__p__1155 - v1118.p).magnitude > 16 then
			v1118.p = l__p__1155;
			v1118.v = u63;
		end;
		v1117.t = v1154 * Vector3.new(1, 0, 1);
		v1120.t = v1154.magnitude;
		if u304 then
			if p435 and not u337 then
				u304.Slot1.Transparency = 0;
				u304.Slot2.Transparency = 0;
				u337 = true;
			elseif not p435 and u337 then
				u304.Slot1.Transparency = 1;
				u304.Slot2.Transparency = 1;
				u337 = false;
			end;
		end;
		if p434 >= 1 then
			u303:step();
			local v1156 = v1153 - l__p__1155 + v1118.p;
			local l__p__1157 = v1119.p;
			local l__p__1158 = v1121.p;
			local v1159 = l__p__1157 < 0.5 and v1053(2 * l__p__1157) or v1054(2 * l__p__1157 - 1);
			local l__p__1160 = v1122.p;
			local l__y__1161 = l__p__1160.y;
			local v1162 = l__p__1158 * 0.5;
			u335 = u335 - l__y__1161 < -v1162 and l__y__1161 - v1162 or (v1162 < u335 - l__y__1161 and l__y__1161 + v1162 or u335);
			local v1163 = u41(0, u335, 0) * u121(0, 0.05 * u11(2 * os.clock()) - 0.55, 0) * v1159 * u121(0, 0.5, 0) + v1156.p;
			local v1164 = l__p__1157 > 0.5 and 2 * l__p__1157 - 1 or 0;
			u338 = 0.5 * (1 - l__p__1157) + 0.5 + (1 - l__p__1158) * 0.5;
			local v1165 = u130(v1156 * u339.sdown, v1163 * u339.pdown, v1164);
			local v1166 = u130(v1156 * u340.sdown, v1163 * u340.pdown, v1164);
			local l__p__1167 = v1166.p;
			local v1168, v1169 = u296(u339.center.p, v1165.p, u338, u339.pos);
			if v1169 then
				v1113.remp = v1169;
			end;
			local v1170 = u297(u340.center.p, l__p__1167, u338);
			if v1168 < 1 then
				u340.pos = (1 - v1168) * (v1166 * u340.center:inverse() * u340.pos) + v1168 * v1170;
				u339.center = v1165;
				u340.center = v1166;
			else
				u339.center = v1165;
				u340.center = v1166;
				local l__magnitude__1171 = (camera.basecframe.p - l__p__1167).magnitude;
				if u340.makesound and l__magnitude__1171 < 192 then
					local v1172, v1173, v1174, v1175 = workspace:FindPartOnRayWithWhitelist(u134(l__p__1167 + u298, u299), roundsystem.raycastwhitelist, true);
					if v1172 then
						local v1176 = l__soundfonts__300[v1175];
						if v1176 then
							if p419.TeamColor ~= l__LocalPlayer__286.TeamColor then
								local v1177 = "enemy_" .. v1176;
								local v1178 = 3.872983346207417 / (l__magnitude__1171 / 5);
							else
								v1177 = "friendly_" .. v1176;
								v1178 = 1.4142135623730951 / (l__magnitude__1171 / 5);
							end;
							if v1177 == "enemy_wood" then
								v1178 = 3.1622776601683795 / (l__magnitude__1171 / 5);
							end;
							if v1120.p <= 15 then
								local v1179 = v1177 .. "walk";
							else
								v1179 = v1177 .. "run";
							end;
							sound.PlaySound(v1179, nil, v1178, 1, nil, nil, u328, 192, 10);
						end;
					end;
				end;
				u339.pos = v1165.p + u338 * (u339.pos - v1165.p).unit;
				u340.pos = v1170;
				u339 = u340;
				u340 = u339;
			end;
			if p434 >= 2 then
				local l__p__1180 = v1114.p;
				local v1181 = u45(l__p__1160.x, l__y__1161);
				local v1182 = v1120.p / 8;
				local v1183 = v1182 < 1 and v1182 or 1;
				local v1184 = v1113.remp * (2 - v1113.remp / u338);
				if v1184 < 0 then
					local v1185 = 0;
				else
					v1185 = v1184;
				end;
				local v1186 = u15(v1163, u301, v1181, 0.5 * l__p__1158 * (1 - l__p__1157) * l__p__1180) * u41(0, v1185 * u339.torsoswing, 0) * u121(0, -3, 0);
				local v1187 = u15(u152, Vector3.new(0, 1, 0), Vector3.new(0, 100, 0) + v1117.v, 1 - v1164) * (v1186 - v1186.p) * u121(0, 3, 0) + v1186.p + Vector3.new(0, v1185 * v1183 / 16, 0);
				u318.CFrame = v1187;
				u339.weld.C0 = u16(1, 1.5, u339.hipcf, v1187:inverse() * u339.pos, v1164 * u9 / 5 * u339.angm) * u339.legcf;
				u340.weld.C0 = u16(1, 1.5, u340.hipcf, v1187:inverse() * (u340.pos + v1185 * v1183 / 3 * Vector3.new(0, 1, 0)), v1164 * u9 / 5 * u340.angm) * u340.legcf;
				local l__p__1188 = v1115.p;
				u330.C0 = v1187:inverse() * u15(v1187 * u121(0, 0.825, 0), u301, v1181) * u41(0, 0, (1 - l__p__1188) * u323) * u121(0, 0.675, 0);
				if u333 then
					u333.Brightness = v1123.p;
				end;
				if u304 then
					if u306 == "gun" then
						local v1189 = u130(u311, u41(v1185 / 10, v1185 * u339.torsoswing, 0) * u130(u313, v1187:inverse() * u15(v1187 * u130(u324, u310, l__p__1188), u301, v1181) * u308 * u121(u325.p) * cframe.fromaxisangle(u326.p) * u309, l__p__1158), l__p__1180);
						u331.C0 = u120(1, 1.5, v1056, v1189 * u314) * v1052;
						u332.C0 = u120(1, 1.5, v1055, v1189 * u315) * v1052;
						u305.C0 = v1189;
					elseif u306 == "KNIFE" then
						local v1190 = u130(u311, u130(u313, v1187:inverse() * u15(v1187 * u310, u301, v1181) * u308 * u309 * u130(u152, u316, v1116.p), l__p__1158), l__p__1180);
						if u307 then
							u331.C0 = u120(1, 1.5, v1056, v1190 * u314) * v1052;
						else
							u331.C0 = u120(1, 1.5, v1056, u314) * v1052;
						end;
						u332.C0 = u120(1, 1.5, v1055, v1190 * u315) * v1052;
						u305.C0 = v1190;
					end;
				end;
			end;
		end;
		debug.profileend();
	end;
	function v1112.updatestate(p436)
		local v1191 = nil;
		local v1192 = nil;
		if p436.healthstate then
			hud.updatehealth(p419, p436.healthstate);
		end;
		if p436.character then
			v1112.updatecharacter(p436.character);
		end;
		if p436.lookangles then
			v1112.setlookangles(p436.lookangles);
		end;
		if p436.stance then
			v1112.setstance(p436.stance);
		end;
		if p436.sprint then
			v1112.setsprint(p436.sprint);
		end;
		if p436.aim then
			v1112.setaim(p436.aim);
		end;
		if p436.weapon then
			v1191 = u52(p436.weapon);
			v1192 = u291(l__ExternalModels__1047, p436.weapon);
			if not v1191 or not v1192 then
				print("Couldn't find a 3rd person weapon");
				return;
			end;
		else
			return;
		end;
		if v1191.type == "KNIFE" then
			v1112.equipknife(v1191, v1192);
			return;
		end;
		v1112.equip(v1191, v1192);
	end;
	network:send("state", p419);
	return v1112;
end;
local function v1193(p437)
	local v1194 = nil;
	if not v1045[p437] then
		v1194 = u302(p437);
		if not v1194 then
			return;
		end;
	elseif v1045[p437] then
		return v1045[p437].updater;
	else
		return;
	end;
	v1045[p437] = {
		updater = v1194, 
		lastupdate = 0, 
		lastlevel = 0, 
		lastupframe = 0
	};
	return v1194;
end;
replication.getupdater = v1193;
network:add("state", function(p438, p439)
	local v1195 = v1193(p438);
	if v1195 then
		v1195.updatestate(p439);
	end;
end);
network:add("stance", function(p440, p441)
	local v1196 = v1193(p440);
	if v1196 then
		v1196.setstance(p441);
	end;
end);
network:add("sprint", function(p442, p443)
	local v1197 = v1193(p442);
	if v1197 then
		v1197.setsprint(p443);
	end;
end);
network:add("lookangles", function(p444, p445)
	local v1198 = v1193(p444);
	if v1198 then
		v1198.setlookangles(p445);
	end;
end);
network:add("aim", function(p446, p447)
	local v1199 = v1193(p446);
	if v1199 then
		v1199.setaim(p447);
	end;
end);
network:add("stab", function(p448)
	local v1200 = v1193(p448);
	if v1200 then
		v1200.stab();
	end;
end);
network:add("updatecharacter", function(p449, p450)
	local v1201 = v1193(p449);
	if v1201 then
		v1201.updatecharacter(p450);
	end;
end);
network:add("equip", function(p451, p452, p453)
	local v1202 = v1193(p451);
	if v1202 then
		local v1203 = u52(p452);
		local v1204 = u291(l__ExternalModels__1047, p452);
		if v1203 and v1204 then
			if v1203.type == "KNIFE" then
				v1202.equipknife(v1203, v1204, p453);
				return;
			end;
			v1202.equip(v1203, v1204, p453);
		end;
	end;
end);
local v1205 = {};
local function u341(p454, p455, p456, p457)
	effects:bloodhit(p454, true, p456, p455.unit * 50);
	if p457 then
		hud:firehitmarker();
	end;
end;
function v1205.Frag(p458, p459, p460, p461)
	local l__range0__1206 = p458.range0;
	local l__range1__1207 = p458.range1;
	local l__damage0__1208 = p458.damage0;
	local l__damage1__1209 = p458.damage1;
	local l__magnitude__1210 = (camera.basecframe.p - p460).magnitude;
	p459.Position = p460;
	if l__magnitude__1210 <= 50 then
		sound.play("fragClose", 2, 1, p459, true);
	elseif l__magnitude__1210 <= 200 then
		sound.play("fragMed", 3, 1, p459, true);
	elseif l__magnitude__1210 > 200 then
		sound.play("fragFar", 3, 1, p459, true);
	end;
	local v1211 = u131("Explosion");
	v1211.Position = p460;
	v1211.BlastRadius = p458.blastradius;
	v1211.BlastPressure = 0;
	v1211.DestroyJointRadiusPercent = 0;
	v1211.Parent = workspace;
	local l__next__1212 = next;
	local v1213, v1214 = game:GetService("Players"):GetPlayers();
	while true do
		local v1215, v1216 = l__next__1212(v1213, v1214);
		if not v1215 then
			break;
		end;
		v1214 = v1215;
		if v1216.TeamColor ~= l__LocalPlayer__286.TeamColor and hud:isplayeralive(v1216) then
			local v1217 = v1193(v1216).getpos();
			if v1217 then
				local v1218 = v1217 - p460;
				local l__magnitude__1219 = v1218.magnitude;
				if l__magnitude__1219 < l__range1__1207 and not workspace:FindPartOnRayWithWhitelist(u134(p460, v1218), roundsystem.raycastwhitelist, true) then
					u341(v1217, v1218, l__magnitude__1219 < l__range0__1206 and l__damage0__1208 or (l__magnitude__1219 < l__range1__1207 and (l__damage1__1209 - l__damage0__1208) / (l__range1__1207 - l__range0__1206) * (l__magnitude__1219 - l__range0__1206) + l__damage0__1208 or l__damage1__1209), p461);
				end;
			end;
		end;	
	end;
end;
network:add("newgrenade", function(p462, p463, p464)
	local v1220 = u52(p463);
	local v1221 = l__getGunModel__125(p463).Trigger:Clone();
	local v1222 = u291(v1221, "Indicator");
	local v1223 = p462 == l__LocalPlayer__286;
	if not v1223 then
		v1221.Trail.Enabled = true;
		if v1222 then
			if p462.TeamColor ~= l__LocalPlayer__286.TeamColor then
				v1222.Enemy.Visible = true;
			else
				v1222.Friendly.Visible = true;
			end;
		end;
	else
		v1221.Transparency = 1;
	end;
	v1221.Anchored = true;
	v1221.Ticking:Play();
	v1221.Parent = l__Ignore__1051.Misc;
	local l__time__1224 = p464.time;
	local l__RenderStepped__1225 = game:GetService("RunService").RenderStepped;
	local u342 = l__time__1224 - tick();
	local u343 = 1;
	local u344 = l__time__1224;
	local function u345(p465)
		if v1220.grenadetype then
			local v1226 = v1205[v1220.grenadetype] and v1220.grenadetype or "Frag";
		else
			v1226 = "Frag";
		end;
		v1205[v1226](v1220, v1221, p465, v1223);
		v1221:Destroy();
	end;
	local u346 = nil;
	u346 = l__RenderStepped__1225:connect(function(p466)
		local v1227 = tick();
		local v1228 = v1227 + u342 * (l__time__1224 + p464.blowuptime - v1227) / (p464.blowuptime + u342);
		if v1221 and p464 then
			local l__frames__1229 = p464.frames;
			local v1230 = l__frames__1229[u343];
			local v1231 = l__frames__1229[u343 + 1];
			if v1231 and l__time__1224 + v1231.t0 < v1228 then
				u343 = u343 + 1;
				v1230 = v1231;
			end;
			local v1232 = v1228 - (l__time__1224 + v1230.t0);
			local v1233 = v1230.p0 + v1232 * v1230.v0 + v1232 * v1232 / 2 * v1230.a + v1230.offset;
			if not v1223 then
				local l__glassbreaks__1234 = v1230.glassbreaks;
				for v1235 = 1, #l__glassbreaks__1234 do
					local v1236 = l__glassbreaks__1234[v1235];
					if v1236.part and u344 < l__time__1224 + v1236.t and l__time__1224 + v1236.t <= v1228 then
						effects:breakwindow(v1236.part, nil, nil, Vector3.new());
					end;
				end;
				v1221.CFrame = cframe.fromaxisangle(v1232 * v1230.rotv) * v1230.rot0 + v1233;
				if v1222 then
					v1222.Enabled = not workspace:FindPartOnRayWithWhitelist(u134(v1233, camera.cframe.p - v1233), roundsystem.raycastwhitelist, true);
				end;
			end;
			if l__time__1224 + p464.blowuptime <= v1228 then
				u345(v1233);
				u346:Disconnect();
			end;
		end;
		u344 = v1228;
	end);
end);
local u347 = os.clock();
local u348 = 1.25;
local function u349()
	return 2.718281828459045 ^ (-(os.clock() - u347) / 1) * (1.25 - u348) + u348;
end;
local function u350()
	u348 = (u349() - 0.5) / 1.1331484530668263 + 0.5;
	u347 = os.clock();
end;
network:add("newbullets", function(p467)
	local v1237 = nil;
	local l__player__1238 = p467.player;
	local l__hideminimap__1239 = p467.hideminimap;
	local l__snipercrack__1240 = p467.snipercrack;
	local l__firepos__1241 = p467.firepos;
	local v1242 = p467.pitch * (1 + 0.05 * math.random());
	local l__bullets__1243 = p467.bullets;
	local v1244 = p467.bulletcolor or Color3.new(0.7843137254901961, 0.27450980392156865, 0.27450980392156865);
	local l__penetrationdepth__1245 = p467.penetrationdepth;
	local v1246 = p467.suppression and 1;
	local v1247 = l__player__1238.TeamColor ~= l__LocalPlayer__286.TeamColor;
	local v1248 = { l__Players__1049, workspace.Terrain, workspace.Ignore, camera.currentcamera };
	local v1249 = v1193(l__player__1238);
	if v1249 then
		v1249.kickweapon(p467.hideflash, v1242, p467.volume);
		v1237 = v1249:getweaponpos();
	end;
	if not l__hideminimap__1239 or l__hideminimap__1239 and (l__firepos__1241 - camera.cframe.p).Magnitude < p467.hiderange then
		local v1250 = v1249.getlookangles();
		local v1251 = u121(l__firepos__1241) * u41(v1250.x, v1250.y, 0);
		if v1251 then
			hud:fireradar(l__player__1238, l__hideminimap__1239, p467.pingdata, v1251);
		end;
	end;
	local v1252 = false;
	for v1253 = 1, #l__bullets__1243 do
		local v1254 = {
			position = l__firepos__1241, 
			velocity = l__bullets__1243[v1253], 
			acceleration = PublicSettings.bulletAcceleration, 
			physicsignore = v1248, 
			color = v1244, 
			size = 0.2, 
			bloom = 0.005, 
			brightness = 400, 
			life = PublicSettings.bulletLifeTime, 
			visualorigin = v1237, 
			penetrationdepth = l__penetrationdepth__1245, 
			thirdperson = true
		};
		local v1255 = v1247;
		if v1255 then
			local u351 = v1252;
			v1255 = function(p468, p469)
				local l__velocity__1256 = p468.velocity;
				local v1257 = p469 * l__velocity__1256;
				local v1258 = p468.position - v1257;
				local l__p__1259 = camera.cframe.p;
				local v1260 = u64(l__p__1259 - v1258, v1257) / u64(v1257, v1257);
				if v1260 > 0 and v1260 < 1 then
					local l__magnitude__1261 = (v1258 + v1260 * v1257 - l__p__1259).magnitude;
					if l__magnitude__1261 < 2 then
						local v1262 = 2;
					else
						v1262 = l__magnitude__1261;
					end;
					local v1263 = u349() * v1246 / (512 * v1262) * l__velocity__1256.magnitude;
					network:send("suppressionassist", l__player__1238, v1263);
					if l__magnitude__1261 < 50 then
						if l__snipercrack__1240 then
							sound.PlaySound("crackBig", nil, 8 / l__magnitude__1261);
						elseif l__magnitude__1261 <= 5 then
							sound.PlaySound("crackSmall", nil, 2);
						else
							sound.PlaySound("whizz", nil, 2 / l__magnitude__1261);
						end;
						if not u351 and l__magnitude__1261 < 15 then
							u351 = true;
							network:send("updatecombat");
						end;
					end;
					camera:suppress(vector.random(v1263, v1263));
					u350();
				end;
			end;
		end;
		v1254.onstep = v1255;
		function v1254.ontouch(p470, p471, p472, p473, p474, p475)
			if p471:IsDescendantOf(l__Map__1050) then
				effects:bullethit(p471, p472, p473, p474, p475, Vector3.new(), true, true);
				return;
			end;
			if p471:IsDescendantOf(l__Players__1049) then
				effects:bloodhit(p472, true, nil, p470.velocity / 10, true);
			end;
		end;
		particle.new(v1254);
	end;
end);
local u352 = 2;
function replication.sethighms(p476)
	u352 = p476;
end;
local u353 = 1;
function replication.setlowms(p477)
	u353 = p477;
end;
local u354 = table.create(game:GetService("Players").MaxPlayers);
local u355 = 0;
local u356 = 0;
local u357 = table.create(game:GetService("Players").MaxPlayers);
local u358 = coroutine.create(function()
	while true do
		if u354[1].lastupframe == u355 then
			coroutine.yield(true);
		elseif u356 < tick() then
			coroutine.yield(true);
		end;
		local v1264 = u13(u354, 1);
		local l__updater__1265 = v1264.updater;
		if l__updater__1265.alive then
			local v1266 = false;
			if l__updater__1265 then
				local v1267, v1268 = l__updater__1265.getpos();
				if v1267 and v1268 then
					v1266 = ScreenCull.sphere(v1267, 4) or ScreenCull.sphere(v1268, 4);
				end;
			end;
			if v1266 then
				l__updater__1265.step(3, true);
			else
				l__updater__1265.step(1, false);
			end;
		end;
		v1264.lastupframe = u355;
		table.insert(u354, v1264);	
	end;
end);
local u359 = nil;
local u360 = v1044;
local function u361()
	for v1269, v1270 in next, v1045 do
		if v1269.Parent then
			if v1270 and v1270.updater and not u357[v1270] then
				u357[v1270] = true;
				table.insert(u354, v1270);
			end;
		else
			print("PLAYER IS GONE", v1269);
			for v1271 = 1, #u354 do
				if u354[v1271] == v1270 then
					warn("Updater was in queue", v1269);
					u13(u354, v1271);
				end;
			end;
			if v1270 and v1270.updater then
				local l__updater__1272 = v1270.updater;
				for v1273, v1274 in pairs(l__updater__1272) do
					l__updater__1272[v1273] = nil;
				end;
			end;
			v1045[v1269] = nil;
			u357[v1270] = nil;
			v1057(v1269);
		end;
	end;
	u355 = u355 + 1;
	u356 = tick() + (u353 + u352) / 1000;
	if #u354 > 0 then
		local v1275, v1276 = coroutine.resume(u358);
		if not v1275 then
			warn("CRITICAL: Replication thread yielded or errored");
			if not u359 then
				u359 = true;
				network:send("debug", string.format("Replication thread broke.\n%s", v1276));
			end;
		end;
	end;
end;
local function u362()
	local v1277 = tick();
	if u360 <= v1277 and char.alive then
		u360 = v1277 + 0.016666666666666666 - (v1277 - u360) % 0.016666666666666666;
		local l__angles__1278 = camera.angles;
		network:send("repupdate", char.rootpart.Position + Vector3.new(0, char.headheight, 0), Vector2.new(l__angles__1278.x, l__angles__1278.y));
	end;
end;
function replication.step()
	u361();
	u362();
end;
function replication.cleanup()
	for v1279 = 1, #u294 do
		u294[v1279]:Destroy();
		u294[v1279] = nil;
	end;
end;
trash.Reset:connect(replication.cleanup);
u9 = print;
u11 = "Requiring menu module";
u9(u11);
u9 = require;
u13 = script;
u21 = u13.Parent;
u11 = u21.UIScript;
u9 = u9(u11);
u11 = {
	superuser = v5, 
	uiscaler = uiscaler, 
	vector = vector, 
	cframe = cframe, 
	network = network, 
	playerdata = u2, 
	effects = effects, 
	animation = animation, 
	input = input, 
	char = char, 
	camera = camera, 
	chat = v7, 
	hud = hud, 
	leaderboard = v9, 
	replication = replication, 
	menu = u3, 
	roundsystem = roundsystem, 
	gamelogic = u53, 
	instancetype = InstanceType
};
u9(u11);
u9 = print;
u11 = "Requiring unlockstats module";
u9(u11);
u9 = require;
u13 = script;
u21 = u13.Parent;
u11 = u21.UnlockStats;
u9 = u9(u11);
u11 = {
	vector = vector, 
	cframe = cframe, 
	network = network, 
	playerdata = u2, 
	event = Event, 
	sequencer = sequencer, 
	particle = particle, 
	sound = sound, 
	effects = effects, 
	tween = tween, 
	animation = animation, 
	input = input, 
	char = char, 
	camera = camera, 
	chat = v7, 
	hud = hud, 
	notify = u106, 
	leaderboard = v9, 
	replication = replication, 
	menu = u3, 
	roundsystem = roundsystem, 
	gamelogic = u53
};
u9(u11);
u9 = print;
u11 = "Loading roundsystem module client";
u9(u11);
u11 = shared;
u9 = u11.require;
u11 = "ObjectiveManagerClient";
u9 = u9(u11);
u21 = game;
u11 = u21.IsA;
u21 = Instance.new;
u61 = game;
u13 = u61.WaitForChild;
u63 = game;
u61 = u63.FindFirstChild;
u64 = game;
u63 = u64.GetChildren;
u64 = CFrame.new;
u45 = CFrame.Angles;
u134 = UDim2.new;
u121 = Color3.new;
u41 = BrickColor.new;
u15 = Vector3.new;
u16 = game;
u130 = "GuiService";
u120 = u16;
u16 = u16.GetService;
u16 = u16(u120, u130);
u120 = Ray.new;
u131 = workspace;
u130 = u131.Map;
u152 = workspace;
u131 = u152.FindPartOnRayWithIgnoreList;
u152 = u13;
u150 = game;
u132 = "ReplicatedStorage";
u152 = u152(u150, u132);
u150 = u13;
u132 = u152;
u229 = "ServerSettings";
u150 = u150(u132, u229);
u132 = u13;
u229 = u150;
u157 = "Countdown";
u132 = u132(u229, u157);
u229 = u13;
u157 = u150;
u291 = "Timer";
u229 = u229(u157, u291);
u157 = u13;
u291 = u150;
u301 = "MaxScore";
u157 = u157(u291, u301);
u291 = u13;
u301 = u150;
u298 = "GhostScore";
u291 = u291(u301, u298);
u301 = u13;
u298 = u150;
u299 = "PhantomScore";
u301 = u301(u298, u299);
u298 = u13;
u299 = u150;
u298 = u298(u299, "ShowResults");
u299 = u13;
u299 = u299(u150, "Quote");
local v1280 = u13(u150, "Winner");
local v1281 = u13(u150, "GameMode");
local l__LocalPlayer__1282 = game:GetService("Players").LocalPlayer;
local v1283 = u13(u13(l__LocalPlayer__1282, "PlayerGui"), "MainGui");
local v1284 = u13(v1283, "CountDown");
local v1285 = u13(v1284, "TeamName");
local v1286 = u13(v1284, "Title");
local v1287 = u13(v1284, "Number");
local v1288 = u13(v1284, "Tip");
local v1289 = u13(u13(v1283, "GameGui"), "Round");
local v1290 = u13(v1289, "Score");
local v1291 = u13(v1289, "GameMode");
local v1292 = u13(v1290, "Ghosts");
local v1293 = u13(v1290, "Phantoms");
local v1294 = u13(v1290, "Time");
local v1295 = u13(v1283, "EndMatch");
local v1296 = u13(v1295, "Quote");
local v1297 = u13(v1295, "Result");
local v1298 = u13(v1295, "Mode");
roundsystem.lock = false;
roundsystem.raycastwhitelist = { u130 };
local v1299 = {};
local u363 = nil;
local u364 = Vector3.new();
function roundsystem.updatekillzone(p478, p479)
	local v1300 = u61(p479, "Killzone");
	u363 = false;
	if v1300 then
		u364 = v1300.Position;
		return;
	end;
	u364 = Vector3.new();
end;
local u365 = nil;
local function v1301(p480)
	u9:clear();
	if u365 then
		u365:Disconnect();
	end;
	local l__AGMP__1302 = p480:FindFirstChild("AGMP");
	if l__AGMP__1302 then
		local l__next__1303 = next;
		local v1304, v1305 = l__AGMP__1302:GetChildren();
		while true do
			local v1306, v1307 = l__next__1303(v1304, v1305);
			if not v1306 then
				break;
			end;
			v1305 = v1306;
			u9:add(v1307);		
		end;
		u365 = l__AGMP__1302.ChildAdded:connect(function(p481)
			u9:add(p481);
		end);
	end;
end;
network:add("newmap", v1301);
v1301(u130);
function roundsystem.checkkillzone(p482, p483, p484)
	if p484.Y < u364.Y and not u363 then
		u363 = true;
		network:send("falldamage", 1000);
	end;
end;
local u366 = v1281;
local u367 = l__LocalPlayer__1282;
function hud.updateteam(p485)
	v1291.Text = u366.Value;
	if u367.TeamColor == game.Teams.Phantoms.TeamColor then
		v1292.Position = u134(0.5, -48, 0, 44);
		v1293.Position = u134(0.5, -48, 0, 28);
		return;
	end;
	v1293.Position = u134(0.5, -48, 0, 44);
	v1292.Position = u134(0.5, -48, 0, 28);
end;
local function v1308()
	v1292.Percent.Size = UDim2.new(u291.Value / u157.Value, 0, 1, 0);
	v1292.Point.Text = u291.Value;
	v1293.Percent.Size = UDim2.new(u301.Value / u157.Value, 0, 1, 0);
	v1293.Point.Text = u301.Value;
end;
local u368 = v1284;
local function u369()
	roundsystem.lock = true;
	if input.consoleon then
		local v1309 = "Press ButtonSelect to return to menu";
	else
		v1309 = "Press F5 to return to menu";
	end;
	v1288.Text = v1309;
	if char.alive then
		if u367.TeamColor == game.Teams.Ghosts.TeamColor then
			local v1310 = "Ghosts";
		else
			v1310 = "Phantoms";
		end;
		v1285.Text = v1310;
		v1285.Visible = true;
		v1285.TextColor3 = u367.TeamColor.Color;
		u368.Visible = true;
		v1287.FontSize = 9;
		v1287.Text = u229.Value;
		for v1311 = 9, 7, -1 do
			v1287.FontSize = v1311;
			task.wait(0.03333333333333333);
		end;
		if u229.Value == 0 then
			task.wait(1);
			roundsystem.lock = false;
			task.wait(2);
			u368.Visible = false;
			return;
		end;
		u368.BackgroundTransparency = 0.5;
		v1287.TextTransparency = 0;
		v1286.TextTransparency = 0;
		v1286.TextStrokeTransparency = 0.5;
	end;
end;
local function u370()
	local v1312 = u229.Value % 60;
	if v1312 < 10 then
		v1312 = "0" .. v1312;
	end;
	v1294.Text = math.floor(u229.Value / 60) .. ":" .. v1312;
end;
local u371 = v1280;
local function v1313()
	if not u298.Value then
		v1295.Visible = false;
		return;
	end;
	roundsystem.lock = true;
	v1296.Text = u299.Value;
	v1295.Visible = true;
	v1298.Text = u366.Value;
	if u371.Value == u367.TeamColor then
		v1297.Text = "VICTORY";
		v1297.TextColor = u41("Bright green");
		return;
	end;
	if u371.Value == u41("Black") then
		v1297.Text = "STALEMATE";
		v1297.TextColor = u41("Bright orange");
		return;
	end;
	v1297.Text = "DEFEAT";
	v1297.TextColor = u41("Bright red");
end;
if u132.Value then
	u369();
end;
v1313();
u229.Changed:connect(function()
	if u132.Value then
		v1294.Text = "COUNTDOWN";
		u369();
		return;
	end;
	if not u298.Value then
		roundsystem.lock = false;
	end;
	u368.Visible = false;
	u370();
end);
u291.Changed:connect(v1308);
u301.Changed:connect(v1308);
u298.Changed:connect(v1313);
v1308();
u9 = print;
u11 = "Loading game logic module";
u9(u11);
u9 = char.loadknife;
u11 = char.loadgun;
u13 = game;
u21 = u13.FindFirstChild;
u13 = nil;
char.loadknife = u13;
u13 = nil;
char.loadgun = u13;
u61 = game;
u13 = u61.Debris;
u61 = Instance.new;
u64 = game;
u63 = u64.ReplicatedStorage;
u64 = game;
u134 = "RunService";
u45 = u64;
u64 = u64.GetService;
u64 = u64(u45, u134);
u134 = game;
u41 = "Players";
u121 = u134;
u134 = u134.GetService;
u134 = u134(u121, u41);
u45 = u134.LocalPlayer;
u134 = u45.PlayerGui;
u121 = {};
u41 = 1;
u15 = nil;
u16 = nil;
u120 = nil;
u130 = nil;
u131 = nil;
u152 = nil;
u150 = nil;
u132 = nil;
u229 = nil;
u157 = 0;
u291 = nil;
u53.currentgun = u291;
u291 = 3;
u53.gammo = u291;
u291 = function(p486)
	u150 = p486;
end;
u53.setsprintdisable = u291;
u291 = function(p487)
	if not u120 and u53.currentgun and not char.grenadehold then
		if p487 == "one" then
			local v1314 = 1;
		elseif p487 == "two" then
			v1314 = 2;
		else
			v1314 = (u41 + p487 - 1) % #u121 + 1;
		end;
		u41 = v1314;
		local v1315 = u121[u41];
		if v1315 and v1315 ~= u53.currentgun then
			u53.currentgun:setequipped(false);
			u53.currentgun = v1315;
			v1315:setequipped(true);
			u120 = true;
			task.wait(0.4);
			u120 = false;
		end;
	end;
end;
u301 = function(p488, p489, p490, p491, p492, p493, p494)
	for v1316 = 1, #u121 do
		local v1317 = u121[v1316];
		if v1317 then
			v1317:destroy("death");
			u121[v1316] = nil;
		end;
	end;
	if u15 then
		u15:destroy();
	end;
	char.loadcharacter(p488, p489);
	char:loadarms(u63.Character["Left Arm"]:Clone(), u63.Character["Right Arm"]:Clone(), "Arm", "Arm");
	u41 = 1;
	u121[1] = u11(p490.Name, false, false, p490.Attachments, p492, p490.Camo, 1);
	if p491 then
		u121[2] = u11(p491.Name, false, false, p491.Attachments, p493, p491.Camo, 2);
	end;
	u15 = u9(p494.Name and "KNIFE", p494.Camo);
	u53.gammo = 3;
	hud:updateammo("GRENADE", 3);
	u3.hidemenu();
	u3.setlighting();
	input.mouse.hide();
	input.mouse.lockcenter();
	hud:updateteam();
	hud:enablegamegui(true);
	hud:set_minimap();
	v7:ingame();
	effects:enableshadows(effects.shadows);
	effects:enablemapshaders(not effects.disableshaders);
	char.alive = true;
	camera.type = "firstperson";
	u53.currentgun = u121[u41];
	u53.currentgun:setequipped(true);
end;
u298 = function(p495, p496, p497)
	u120 = true;
	if u53.currentgun ~= u15 then
		u15:destroy();
	else
		u53.currentgun:setequipped(false);
	end;
	if not p497 then
		task.wait(0.4);
	end;
	u15 = nil;
	if not p497 then
		task.wait(0.1);
	end;
	u15 = u9(p495, p496);
	u53.currentgun = u15;
	u53.currentgun:setequipped(true);
	if not p497 then
		task.wait(0.4);
	end;
	u120 = false;
end;
u299 = function(p498, p499, p500, p501, p502, p503, p504, p505)
	u120 = true;
	u41 = p504;
	if u53.currentgun then
		u53.currentgun:setequipped(false);
	end;
	if not p505 then
		task.wait(0.4);
	end;
	if u121[p504] then
		u121[p504]:destroy();
		u121[p504] = nil;
	end;
	if not p505 then
		task.wait(0.4);
	end;
	local v1318 = u11(p498, p499, p500, p501, p502, p503, p504);
	u121[p504] = v1318;
	u53.currentgun = v1318;
	u130 = v1318;
	v1318:setequipped(true);
	if not p505 then
		task.wait(0.4);
	end;
	u120 = false;
end;
u371 = function(p506)
	if u121[p506] then
		u121[p506]:remove();
		u121[p506] = nil;
	end;
end;
u367 = input.mouse;
u366 = u367.onbuttondown;
u367 = u366;
u366 = u366.connect;
u366(u367, function(p507)
	if not u53.currentgun or u120 then
		return;
	end;
	if p507 == "left" and u53.currentgun.shoot then
		if u53.currentgun.inspecting() then
			u53.currentgun:reloadcancel(true);
		end;
		if u53.currentgun.type == "KNIFE" then
			u53.currentgun:shoot(false, "stab1");
			return;
		else
			u53.currentgun:shoot(true);
			return;
		end;
	end;
	if p507 == "right" then
		if u53.currentgun.inspecting() then
			u53.currentgun:reloadcancel(true);
		end;
		if u53.currentgun.setaim then
			u53.currentgun:setaim(true);
			return;
		end;
		if u53.currentgun.type == "KNIFE" then
			u53.currentgun:shoot(false, "stab2");
		end;
	end;
end);
u367 = input.mouse;
u366 = u367.onscroll;
u367 = u366;
u366 = u366.connect;
u366(u367, function(...)
	if not char.grenadehold then
		u291(...);
	end;
end);
u367 = input.mouse;
u366 = u367.onbuttonup;
u367 = u366;
u366 = u366.connect;
u366(u367, function(p508)
	if not u53.currentgun then
		return;
	end;
	if p508 == "left" and u53.currentgun.shoot then
		u53.currentgun:shoot(false);
		return;
	end;
	if p508 == "right" and u53.currentgun.setaim then
		u53.currentgun:setaim(false);
	end;
end);
u367 = input.keyboard;
u366 = u367.onkeydown;
u367 = u366;
u366 = u366.connect;
u366(u367, function(p509)
	if not u53.currentgun or not char.alive then
		return;
	end;
	if roundsystem.lock and p509 ~= "h" and p509 ~= "q" and p509 ~= "f" and p509 ~= "one" and p509 ~= "two" and p509 ~= "three" then
		return;
	end;
	if u64:IsStudio() then
		input.mouse:lockcenter();
	end;
	if p509 == "space" then
		if u157 < tick() then
			if char:jump(4) then
				u157 = tick() + 0.6666666666666666;
				return;
			else
				u157 = tick() + 0.25;
				return;
			end;
		end;
	else
		if p509 == "c" then
			if char.getslidecondition() and not u16 then
				u16 = true;
				u150 = true;
				char:setmovementmode("crouch", u16);
				task.wait(0.2);
				u150 = false;
				task.wait(0.9);
				u16 = false;
				return;
			else
				if char.movementmode == "crouch" then
					local v1319 = "prone";
				else
					v1319 = "crouch";
				end;
				char:setmovementmode(v1319);
				return;
			end;
		end;
		if p509 == "x" then
			local v1320 = nil;
			local v1321 = nil;
			if char.sprinting() then
				if not u16 then
					u16 = true;
					u150 = true;
					char:setmovementmode("prone", u16);
					task.wait(0.8);
					u150 = false;
					if char.sprinting() and not u150 then
						char:setsprint(true);
					end;
					task.wait(1.8);
					u16 = false;
					return;
				end;
				v1320 = u16;
				v1321 = v1320;
				if not v1321 then
					if char.movementmode == "crouch" then
						local v1322 = "stand";
					else
						v1322 = "crouch";
					end;
					char:setmovementmode(v1322);
					return;
				end;
			else
				v1320 = u16;
				v1321 = v1320;
				if not v1321 then
					if char.movementmode == "crouch" then
						v1322 = "stand";
					else
						v1322 = "crouch";
					end;
					char:setmovementmode(v1322);
					return;
				end;
			end;
		else
			if p509 == "leftcontrol" then
				if char.getslidecondition() and not u16 then
					u16 = true;
					u150 = true;
					char:setmovementmode("crouch", u16);
					task.wait(0.2);
					u150 = false;
					task.wait(0.9);
					u16 = false;
					return;
				else
					char:setmovementmode("prone");
					return;
				end;
			end;
			if p509 == "z" then
				local v1323 = nil;
				local v1324 = nil;
				if char.sprinting() then
					if not u16 then
						u16 = true;
						u150 = true;
						char:setmovementmode("prone", u16);
						task.wait(0.8);
						u150 = false;
						task.wait(1.8);
						u16 = false;
						return;
					end;
					v1323 = u16;
					v1324 = v1323;
					if not v1324 then
						char:setmovementmode("stand");
						return;
					end;
				else
					v1323 = u16;
					v1324 = v1323;
					if not v1324 then
						char:setmovementmode("stand");
						return;
					end;
				end;
			elseif p509 == "r" then
				if u53.currentgun.reload and not u53.currentgun.data.loosefiring then
					u53.currentgun:reload();
					return;
				end;
			elseif p509 == "e" then
				if not char.grenadehold and u53.currentgun.playanimation and not u152 then
					u152 = true;
					if hud:spot() then
						u53.currentgun:playanimation("spot");
					end;
					task.wait(1);
					u152 = false;
					return;
				end;
			else
				if p509 == "f" then
					if u132 or char.grenadehold then
						return;
					elseif u53.currentgun == u15 then
						u53.currentgun:shoot();
						return;
					else
						u132 = true;
						if u15 then
							u130 = u53.currentgun;
							u53.currentgun = u15;
						end;
						u53.currentgun:setequipped(true, "stab1");
						u120 = true;
						task.wait(0.5);
						if not input.keyboard.down.f and u130 then
							u53.currentgun = u130;
							if u130 then
								u130:setequipped(true);
							end;
						end;
						u120 = false;
						task.wait(0.5);
						u132 = false;
						return;
					end;
				end;
				if p509 == "g" then
					if not u132 and not u120 and not char.grenadehold and u53.gammo > 0 then
						u131 = char:loadgrenade("FRAG", u53.currentgun);
						u131:setequipped(true);
						u120 = true;
						task.wait(0.3);
						u120 = false;
						u131:pull();
						return;
					end;
				elseif p509 == "h" then
					if u53.currentgun.isaiming() and u53.currentgun.isblackscope() then
						return;
					end;
					if not char.grenadehold and not u152 and not u53.currentgun.inspecting() then
						u53.currentgun:playanimation("inspect");
						return;
					end;
				elseif p509 == "leftshift" then
					if u53.currentgun.isaiming() and u53.currentgun.isblackscope() then
						return;
					end;
					if not u150 then
						if input.sprinttoggle then
							char:setsprint(not char.sprinting());
							return;
						else
							char:setsprint(true);
							return;
						end;
					end;
				elseif p509 == "w" then
					if not u21(u134, "Doubletap") and not char.sprinting() then
						local v1325 = u61("Model");
						v1325.Name = "Doubletap";
						v1325.Parent = u134;
						u13:AddItem(v1325, 0.2);
						return;
					end;
					if u53.currentgun.isaiming() and u53.currentgun.isblackscope() then
						return;
					end;
					if not u150 then
						char:setsprint(true);
						return;
					end;
				elseif p509 == "q" then
					if u53.currentgun.inspecting() then
						u53.currentgun:reloadcancel(true);
					end;
					if u53.currentgun.setaim then
						u53.currentgun:setaim(not u53.currentgun.isaiming());
						return;
					end;
				elseif p509 == "m" then
					if v5 then
						if input.mouse:visible() then
							input.mouse:hide();
							return;
						else
							input.mouse:show();
							return;
						end;
					end;
				elseif p509 == "t" then
					if u53.currentgun.toggleattachment then
						u53.currentgun:toggleattachment();
						return;
					end;
				elseif p509 == "v" then
					if u120 or char.grenadehold then
						return;
					end;
					if hud:getuse() then
						local u372 = u53.currentgun;
						task.delay(0.15, function()
							if not input.keyboard.down.v then
								return;
							end;
							local v1326 = workspace.Ignore.GunDrop:GetChildren();
							local v1327 = 8;
							local v1328 = nil;
							local v1329 = nil;
							for v1330 = 1, #v1326 do
								local v1331 = v1326[v1330];
								if v1331.Name == "Dropped" then
									local l__magnitude__1332 = (v1331.Slot1.Position - char.rootpart.Position).magnitude;
									if l__magnitude__1332 < v1327 then
										if u21(v1331, "Gun") then
											v1327 = l__magnitude__1332;
											v1328 = v1331;
											v1329 = nil;
										elseif u21(v1331, "Knife") then
											v1327 = l__magnitude__1332;
											v1329 = v1331;
											v1328 = nil;
										end;
									end;
								end;
							end;
							if not v1328 then
								if v1329 then
									network:send("swapweapon", v1329);
									print("sent knife");
								end;
								return;
							end;
							if u372 == u15 then
								u41 = 2;
								u53.currentgun = u121[u41];
								u372 = u53.currentgun;
								u53.currentgun:setequipped(true);
							end;
							network:send("swapweapon", v1328, u41);
						end);
						return;
					end;
					if u53.currentgun.nextfiremode then
						u53.currentgun:nextfiremode();
						return;
					end;
				elseif p509 == "one" or p509 == "two" then
					if not char.grenadehold then
						u291(p509);
						return;
					end;
				else
					if p509 == "three" then
						if u53.currentgun == u15 or char.grenadehold then
							return;
						else
							if u15 then
								u130 = u53.currentgun;
								u53.currentgun = u15;
							end;
							u53.currentgun:setequipped(true);
							u120 = true;
							task.wait(0.5);
							u120 = false;
							return;
						end;
					end;
					if p509 == "f5" or p509 == "f8" then
						if u229 or input.keyboard.down.leftshift then
							return;
						end;
						u229 = true;
						char:despawn();
						if not InstanceType.IsTest() and not InstanceType.IsVIP() then
							local v1333 = game:GetService("ReplicatedStorage"):WaitForChild("Misc").RespawnGui.Title:Clone();
							v1333.Parent = u45.PlayerGui:FindFirstChild("MainGui");
							for v1334 = 5, 0, -1 do
								if not v1 then
									v1333.Count.Text = v1334;
									task.wait(1);
								end;
							end;
							v1333:Destroy();
						end;
						u229 = false;
					end;
				end;
			end;
		end;
	end;
end);
u367 = input.keyboard;
u366 = u367.onkeyup;
u367 = u366;
u366 = u366.connect;
u366(u367, function(p510)
	if not u53.currentgun then
		return;
	end;
	if p510 ~= "leftshift" then
		if p510 == "w" and not input.keyboard.down.leftshift and not input.sprinttoggle then
			char:setsprint(false);
		end;
	elseif not input.sprinttoggle then
		char:setsprint(false);
	end;
end);
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "a", "space");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "x", "r");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "r1", "g");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "up", "h");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "r3", "f");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "right", "v");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "down", "e");
u366 = input.controller;
u367 = u366;
u366 = u366.map;
u366(u367, "left", "t");
u366 = nil;
u367 = input.controller.onbuttondown;
u367 = u367.connect;
u367(u367, function(p511)
	if not u53.currentgun then
		return;
	end;
	if roundsystem.lock then
		return;
	end;
	if p511 == "b" then
		if char.movementmode == "crouch" then
			char:setmovementmode("prone");
			return;
		elseif char.sprinting() and not u16 then
			u16 = true;
			char:setmovementmode("crouch", u16);
			task.wait(1);
			u16 = false;
			return;
		else
			char:setmovementmode("crouch");
			return;
		end;
	end;
	if p511 == "r2" and u53.currentgun.shoot then
		if u53.currentgun.inspecting() then
			u53.currentgun:reloadcancel(true);
		end;
		u53.currentgun:shoot(true);
		return;
	end;
	if p511 == "l2" then
		if u53.currentgun.inspecting() then
			u53.currentgun:reloadcancel(true);
		end;
		if u53.currentgun.setaim then
			u53.currentgun:setaim(true);
			return;
		end;
		if u53.currentgun.type == "KNIFE" then
			u53.currentgun:shoot(false, "stab2");
			return;
		end;
	elseif p511 == "l1" then
		if char.sprinting() and not u16 then
			u16 = true;
			u150 = true;
			char:setmovementmode("prone", u16);
			task.wait(0.8);
			u150 = false;
			task.wait(1.8);
			u16 = false;
			return;
		end;
		if not char.grenadehold and u53.currentgun.playanimation and not u152 then
			u152 = true;
			if hud:spot() then
				u53.currentgun:playanimation("spot");
			end;
			task.wait(1);
			u152 = false;
			return;
		end;
	elseif p511 == "y" then
		if u120 or char.grenadehold then
			return;
		end;
		u366 = false;
		if hud:getuse() then
			task.delay(0.2, function()
				if not input.controller.down.y then
					return;
				end;
				u366 = true;
				local v1335 = workspace.Ignore.GunDrop:GetChildren();
				local v1336 = 8;
				local v1337 = nil;
				local v1338 = nil;
				for v1339 = 1, #v1335 do
					local v1340 = v1335[v1339];
					if v1340.Name == "Dropped" then
						local l__magnitude__1341 = (v1340.Slot1.Position - char.rootpart.Position).magnitude;
						if l__magnitude__1341 < v1336 then
							if u21(v1340, "Gun") then
								v1336 = l__magnitude__1341;
								v1337 = v1340;
								v1338 = nil;
							elseif u21(v1340, "Knife") then
								v1336 = l__magnitude__1341;
								v1338 = v1340;
								v1337 = nil;
							end;
						end;
					end;
				end;
				if not v1337 then
					if v1338 then
						network:send("swapweapon", v1338);
					end;
					return;
				end;
				if u53.currentgun == u15 then
					u41 = 2;
					u53.currentgun = u121[u41];
					u53.currentgun:setequipped(true);
				end;
				network:send("swapweapon", v1337, u41);
			end);
			return;
		end;
	elseif p511 == "l3" then
		if u53.currentgun.isaiming() and u53.currentgun.isblackscope() then
			u53.steadytoggle = not u53.steadytoggle;
			return;
		end;
		if not u150 then
			if u53.currentgun.isaiming() and u53.currentgun.setaim then
				u53.steadytoggle = false;
				u53.currentgun:setaim(false);
			end;
			char:setsprint(not char.sprinting());
			return;
		end;
	elseif p511 == "select" then
		if u229 then
			return;
		end;
		u229 = true;
		for v1342 = 1, 20 do
			task.wait(0.1);
			if not u229 then
				return;
			end;
		end;
		if u229 then
			u229 = false;
			char:despawn();
		end;
	end;
end);
u367 = input.controller.onbuttonup;
u367 = u367.connect;
u367(u367, function(p512)
	if not u53.currentgun then
		return;
	end;
	if p512 == "r2" then
		u53.currentgun:shoot(false);
		return;
	end;
	if p512 == "y" then
		if not u366 then
			u291(1);
			return;
		end;
	elseif p512 == "l2" and u53.currentgun.setaim then
		u53.steadytoggle = false;
		if u53.currentgun.isaiming() then
			u53.currentgun:setaim(false);
			return;
		end;
	elseif p512 == "select" and u229 then
		u229 = false;
	end;
end);
u367 = function()
	if not u53.currentgun then
		return;
	end;
	if input.controller.down.b and (input.controller.down.b + 0.5 < tick() and char.movementmode ~= "prone") then
		char:setmovementmode("prone");
	end;
end;
u53.controllerstep = u367;
u367 = char.ondied;
u367 = u367.connect;
u367(u367, function(p513)
	u157 = 0;
	hud:setscope(false);
	if u53.currentgun then
		u53.currentgun:setequipped(false, "death");
		u53.currentgun = nil;
	end;
	if not p513 then
		task.wait(5);
	end;
	u3:loadmenu(true);
	if not u21(u45, "ForceR") then
		char:setmovementmode("stand");
	end;
end);
u368 = u301;
u367 = network.add;
u367(network, "spawn", u368);
u368 = u299;
u367 = network.add;
u367(network, "swapgun", u368);
u368 = u371;
u367 = network.add;
u367(network, "removeweapon", u368);
u368 = u298;
u367 = network.add;
u367(network, "swapknife", u368);
u368 = function(p514, p515, p516)
	if u121[p514] then
		u121[p514]:addammo(p515, p516);
	end;
end;
u367 = network.add;
u367(network, "addammo", u368);
u367 = u3.loadmenu;
u367(u3);
u21 = "setuiscale";
u13 = uiscaler.setscale;
u11 = network;
u9 = network.add;
u9(u11, u21, u13);
u9 = Instance.new;
u11 = Vector3.new;
u21 = CFrame.new;
u61 = game;
u13 = u61.FindFirstChild;
u64 = workspace;
u63 = u64.Ignore;
u61 = u63.DeadBody;
u64 = shared;
u63 = u64.require;
u64 = "bodysetup";
u63 = u63(u64);
u45 = shared;
u64 = u45.require;
u45 = "ragdolltable";
u64 = u64(u45);
u45 = function(p517, p518)
	local v1343 = u9("Part");
	v1343:BreakJoints();
	v1343.Shape = "Ball";
	v1343.CastShadow = false;
	v1343.TopSurface = 0;
	v1343.BottomSurface = 0;
	v1343.formFactor = "Custom";
	v1343.Size = Vector3.new(0.25, 0.25, 0.25);
	v1343.Transparency = 1;
	v1343.CollisionGroupId = 3;
	local v1344 = u9("Weld");
	v1344.Part0 = p517;
	v1344.Part1 = v1343;
	v1344.C0 = not p518 and u21(0, -0.5, 0) or p518;
	v1344.Parent = v1343;
	v1343.Parent = p517;
end;
u134 = function(p519, p520)
	local v1345 = u9("Part");
	v1345.CastShadow = false;
	v1345.Size = Vector3.new(0.1, 0.1, 0.1);
	v1345.Shape = "Ball";
	v1345.TopSurface = "Smooth";
	v1345.BottomSurface = "Smooth";
	v1345.Transparency = 1;
	v1345.CanCollide = false;
	v1345.CollisionGroupId = 3;
	v1345.Parent = p519;
	game.Debris:AddItem(v1345, 5);
	local v1346 = u9("Weld");
	v1346.Part0 = p519;
	v1346.Part1 = v1345;
	v1346.C0 = u64[p519.Name].c;
	v1346.Parent = v1345;
	local v1347 = u9("Attachment");
	v1347.CFrame = u64[p519.Name].a;
	v1347.Parent = p520;
	local v1348 = u9("Attachment");
	v1348.CFrame = u64[p519.Name].b;
	v1348.Parent = p519;
	if u64[p519.Name].d0 then
		v1347.Axis = u64[p519.Name].d0;
		v1348.Axis = u64[p519.Name].d1;
	end;
	local v1349 = u9("BallSocketConstraint");
	v1349.Attachment0 = v1347;
	v1349.Attachment1 = v1348;
	v1349.Restitution = 0.5;
	v1349.LimitsEnabled = true;
	v1349.UpperAngle = 70;
	v1349.Parent = p520;
end;
u121 = function(p521, p522, p523)
	local v1350 = u9("Model");
	local v1351 = nil;
	local v1352 = nil;
	local v1353 = nil;
	local v1354 = nil;
	local v1355 = nil;
	local v1356 = nil;
	local v1357 = nil;
	if p521 then
		local v1358 = p521:GetChildren();
		for v1359 = 1, #v1358 do
			local v1360 = v1358[v1359];
			if v1360:IsA("Part") and (v1360.Transparency == 0 or u63[v1360.Name]) then
				local v1361 = u9("Part");
				v1361.TopSurface = 0;
				v1361.BottomSurface = 0;
				v1361.Size = v1360.Size;
				v1361.Color = v1360.Color;
				v1361.CastShadow = false;
				v1361.Anchored = false;
				v1361.Name = v1360.Name;
				v1361.CFrame = v1360.CFrame;
				v1361.Velocity = v1360.Velocity;
				v1361.CollisionGroupId = 3;
				v1361.Parent = v1350;
				local v1362 = v1360:GetChildren();
				for v1363 = 1, #v1362 do
					local v1364 = v1362[v1363];
					if v1364:IsA("SpecialMesh") or v1364:IsA("Decal") then
						v1364:Clone().Parent = v1361;
					end;
				end;
				if v1360.Name == "Head" then
					v1351 = v1361;
				end;
				if v1360.Name == "Torso" then
					v1352 = v1361;
				end;
				if v1360.Name == "Left Arm" then
					v1353 = v1361;
				end;
				if v1360.Name == "Right Arm" then
					v1354 = v1361;
				end;
				if v1360.Name == "Left Leg" then
					v1355 = v1361;
				end;
				if v1360.Name == "Right Leg" then
					v1356 = v1361;
				end;
				if v1360 == p522 then
					v1357 = v1361;
				end;
			elseif v1360:IsA("Shirt") or v1360:IsA("Pants") then
				v1360:Clone().Parent = v1350;
			end;
		end;
		if v1352 then
			if v1351 then
				local v1365 = u9("Weld");
				v1365.Part0 = v1352;
				v1365.Part1 = v1351;
				v1365.C0 = u21(0, 1.5, 0);
				v1365.Parent = v1352;
				local v1366 = u13(v1351, "Mesh");
				if v1366 then
					v1366.Scale = Vector3.new(1.15, 1.15, 1.15);
					v1366.Offset = Vector3.new(0, 0.1, 0);
				end;
			end;
			if v1354 then
				u134(v1354, v1352);
			end;
			if v1353 then
				u134(v1353, v1352);
			end;
			if v1356 then
				u134(v1356, v1352);
			end;
			if v1355 then
				u134(v1355, v1352);
			end;
			u45(v1352, u21(0, 0.5, 0));
			local l__next__1367 = next;
			local v1368, v1369 = v1350:GetDescendants();
			while true do
				local v1370, v1371 = l__next__1367(v1368, v1369);
				if not v1370 then
					break;
				end;
				v1369 = v1370;
				if v1371:IsA("Decal") then
					v1371.Transparency = 0;
				end;			
			end;
			v1350.Name = "Dead";
			v1350.Parent = u61;
			if v1357 then
				v1357:ApplyImpulseAtPosition(v1357.Velocity + p523, v1357.Position);
			end;
			task.delay(5, function()
				local l__next__1372 = next;
				local v1373, v1374 = v1350:GetChildren();
				while true do
					local v1375, v1376 = l__next__1372(v1373, v1374);
					if not v1375 then
						break;
					end;
					v1374 = v1375;
					if v1376:IsA("BasePart") then
						v1376.Anchored = true;
					end;				
				end;
			end);
			task.delay(30, function()
				for v1377 = 1, 20 do
					v1354.Transparency = v1377 / 20;
					v1353.Transparency = v1377 / 20;
					v1356.Transparency = v1377 / 20;
					v1355.Transparency = v1377 / 20;
					v1352.Transparency = v1377 / 20;
					v1351.Transparency = v1377 / 20;
					task.wait(0.016666666666666666);
				end;
				v1350:Destroy();
			end);
		end;
	end;
end;
network:add("died", function(p524, p525, p526, p527)
	if p525 then
		if p526 and effects.ragdolls then
			u121(p525, p526, p527);
		end;
		p525.Parent = nil;
	end;
	if replication.removecharacterhash then
		replication.removecharacterhash(p524);
	end;
	if replication.getupdater then
		local v1378 = replication.getupdater(p524);
		if v1378 then
			v1378.died();
		end;
	end;
end);
u9 = {};
u11 = "failed to load";
u21 = "http request failed";
u13 = "could not fetch";
u61 = "download sound";
u63 = "thumbnail";
u9[1] = u11;
u9[2] = u21;
u9[3] = u13;
u9[4] = u61;
u9[5] = u63;
u21 = game;
u61 = "LogService";
u13 = u21;
u21 = u21.GetService;
u21 = u21(u13, u61);
u11 = u21.MessageOut;
u13 = function(p528, p529)
	if p529 == Enum.MessageType.MessageError then
		for v1379 = 1, #u9 do
			if string.find(string.lower(p528), u9[v1379]) then
				return;
			end;
		end;
		network:send("debug", p528);
	end;
end;
u21 = u11;
u11 = u11.connect;
u11(u21, u13);
u11 = print;
u21 = "Framework finished loading, duration:";
u61 = tick;
u61 = u61();
u13 = u61 - v4;
u11(u21, u13);
u21 = game;
u61 = "RunService";
u13 = u21;
u21 = u21.GetService;
u21 = u21(u13, u61);
u11 = u21.Heartbeat;
u21 = u11;
u11 = u11.wait;
u11(u21);
u21 = network;
u11 = network.ready;
u11(u21);
u21 = shared;
u11 = u21.close;
u11();
u11 = trash.Reset;
u13 = sound.clear;
u21 = u11;
u11 = u11.connect;
u11(u21, u13);
u13 = "input";
u61 = input.step;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61);
u13 = "char";
u61 = char.step;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61);
u13 = "camera";
u61 = camera.step;
u63 = {};
u64 = "input";
u45 = "char";
u63[1] = u64;
u63[2] = u45;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "hud";
u61 = hud.step;
u63 = {};
u64 = "char";
u45 = "camera";
u134 = "weaponstep";
u63[1] = u64;
u63[2] = u45;
u63[3] = u134;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "notify";
u61 = u106.step;
u63 = {};
u64 = "char";
u63[1] = u64;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "leaderboard";
u61 = v9.step;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61);
u13 = "weaponstep";
u61 = char.animstep;
u63 = {};
u64 = "char";
u45 = "particle";
u134 = "camera";
u63[1] = u64;
u63[2] = u45;
u63[3] = u134;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "controllerstep";
u61 = u53.controllerstep;
u63 = {};
u64 = "char";
u45 = "input";
u63[1] = u64;
u63[2] = u45;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "menu";
u61 = u3.step;
u63 = {};
u64 = "camera";
u63[1] = u64;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "particle";
u61 = particle.step;
u63 = {};
u64 = "camera";
u63[1] = u64;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "tween";
u61 = tween.step;
u63 = {};
u64 = "weaponstep";
u63[1] = u64;
u21 = RenderSteppedRunner;
u11 = RenderSteppedRunner.addTask;
u11(u21, u13, u61, u63);
u13 = "replication";
u61 = replication.step;
u21 = HeartbeatRunner;
u11 = HeartbeatRunner.addTask;
u11(u21, u13, u61);
u13 = "daycycle";
u61 = effects.daycyclestep;
u21 = HeartbeatRunner;
u11 = HeartbeatRunner.addTask;
u11(u21, u13, u61);
u13 = "blood";
u61 = effects.bloodstep;
u21 = HeartbeatRunner;
u11 = HeartbeatRunner.addTask;
u11(u21, u13, u61);
u13 = "hudbeat";
u61 = hud.beat;
u21 = HeartbeatRunner;
u11 = HeartbeatRunner.addTask;
u11(u21, u13, u61);
u13 = "radar";
u61 = hud.radarstep;
u21 = HeartbeatRunner;
u11 = HeartbeatRunner.addTask;
u11(u21, u13, u61);
u11 = workspace;
u13 = "Map";
u21 = u11;
u11 = u11.FindFirstChild;
u11 = u11(u21, u13);
u61 = workspace;
u13 = u61.Ignore;
u21 = u13.GunDrop;
u63 = "dropcheck";
u64 = function()
	local v1380 = u21:GetChildren();
	local v1381 = 8;
	hud:gundrop(false);
	if char.alive then
		for v1382 = 1, #v1380 do
			local v1383 = v1380[v1382];
			if v1383.Name == "Dropped" and v1383:FindFirstChild("Slot1") then
				local l__magnitude__1384 = (v1383.Slot1.Position - char.rootpart.Position).magnitude;
				if l__magnitude__1384 < v1381 then
					v1381 = l__magnitude__1384;
					if v1383:FindFirstChild("Gun") then
						hud:gundrop(v1383, v1383.Gun.Value);
					elseif v1383:FindFirstChild("Knife") then
						hud:gundrop(v1383, v1383.Knife.Value);
					end;
				end;
			end;
		end;
	end;
end;
u61 = HeartbeatRunner;
u13 = HeartbeatRunner.addTask;
u13(u61, u63, u64);
u63 = "flagcheck";
u64 = function()
	local v1385 = nil;
	if char.alive then
		v1385 = u21:GetChildren();
		hud:capping(false);
		if not u11 then
			return;
		end;
	else
		hud:capping(false);
		return;
	end;
	local l__AGMP__1386 = u11:FindFirstChild("AGMP");
	if l__AGMP__1386 then
		local v1387 = l__AGMP__1386:GetChildren();
		for v1388 = 1, #v1387 do
			local v1389 = v1387[v1388];
			if v1389:FindFirstChild("IsCapping") and v1389.IsCapping.Value and v1389.TeamColor.Value ~= l__LocalPlayer__3.TeamColor and char.rootpart and (v1389.Base.Position - char.rootpart.Position).magnitude < 15 then
				hud:capping(v1389, v1389.CapPoint.Value);
			end;
		end;
	end;
	for v1390 = 1, #v1385 do
		local v1391 = v1385[v1390];
		if v1391:FindFirstChild("Base") then
			if v1391.Name == "FlagDrop" then
				if (v1391.Base.Position - char.rootpart.Position).magnitude < 8 then
					if v1391.TeamColor.Value == l__LocalPlayer__3.TeamColor and v1391:FindFirstChild("IsCapping") and v1391.IsCapping.Value then
						hud:capping(v1391, v1391.CapPoint.Value, "ctf");
					end;
					network:send("captureflag", v1391.TeamColor.Value);
				end;
			elseif v1391.Name == "DogTag" and (v1391.Base.Position - char.rootpart.Position).magnitude < 6 then
				network:send("capturedogtag", v1391);
			end;
		end;
	end;
end;
u61 = HeartbeatRunner;
u13 = HeartbeatRunner.addTask;
u13(u61, u63, u64);
u11 = Instance.new;
u21 = "BindableEvent";
u11 = u11(u21);
u21 = u11.Event;
u61 = function()
	char:despawn();
end;
u13 = u21;
u21 = u21.Connect;
u21(u13, u61);
u21 = game;
u61 = "StarterGui";
u13 = u21;
u21 = u21.GetService;
u21 = u21(u13, u61);
u61 = "ResetButtonCallback";
u63 = u11;
u13 = u21;
u21 = u21.SetCore;
u21(u13, u61, u63);