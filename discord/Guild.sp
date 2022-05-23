public int DiscordBot_CreateGuild(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	OnDiscordGuildCreated cb = GetNativeCell(3);

	DataPack pack = new DataPack();
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);

	CreateGuild(bot, guild, pack);
}

public int DiscordBot_AddRole(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordUser user = GetNativeCell(3);
	DiscordRole role = GetNativeCell(4);

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char userid[64];
	user.GetID(userid, sizeof(userid));

	char roleid[64];
	role.GetID(roleid, sizeof(roleid));
	AddRole(bot, guildid, userid, roleid);
}

public int DiscordBot_AddRoleID(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	char userid[64];
	GetNativeString(3, userid, sizeof(userid));

	char roleid[64];
	GetNativeString(4, roleid, sizeof(roleid));
	AddRole(bot, guildid, userid, roleid);
}

public int DiscordBot_RemoveRole(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordUser user = GetNativeCell(3);
	DiscordRole role = GetNativeCell(4);

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char userid[64];
	user.GetID(userid, sizeof(userid));

	char roleid[64];
	role.GetID(roleid, sizeof(roleid));
	RemoveRole(bot, guildid, userid, roleid);
}

public int DiscordBot_RemoveRoleID(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	char userid[64];
	GetNativeString(3, userid, sizeof(userid));

	char roleid[64];
	GetNativeString(4, roleid, sizeof(roleid));
	RemoveRole(bot, guildid, userid, roleid);
}

public int DiscordBot_GetGuild(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	bool with_counts = GetNativeCell(3);
	OnGetDiscordGuild cb = view_as<OnGetDiscordGuild>(GetNativeFunction(4));

	DataPack pack = new DataPack();
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);
	GetGuild(bot, guildid, with_counts, pack);
}

public int DiscordBot_GetGuildMember(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordUser user = GetNativeCell(3);
	OnGetDiscordGuildUser cb = view_as<OnGetDiscordGuildUser>(GetNativeFunction(4));

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char userid[64];
	user.GetID(userid, sizeof(userid));

	DataPack pack = new DataPack();
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);
	GetGuildMember(bot, guildid, userid, pack);
}

public int DiscordBot_GetGuildMemberID(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	char userid[64];
	GetNativeString(3, userid, sizeof(userid));

	OnGetDiscordGuildUser cb = view_as<OnGetDiscordGuildUser>(GetNativeFunction(4));

	DataPack pack = new DataPack();
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);
	GetGuildMember(bot, guildid, userid, pack);
}

static void CreateGuild(DiscordBot bot, DiscordGuild guild, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds");
	SendRequest(bot, route, guild, k_EHTTPMethodPOST, OnDiscordDataReceived, _, pack);
}

static void AddRole(DiscordBot bot, const char[] guildid, const char[] userid, const char[] roleid)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/members/%s/roles/%s", guildid, userid, roleid);
	SendRequest(bot, route, _, k_EHTTPMethodPUT);
}

static void RemoveRole(DiscordBot bot, const char[] guildid, const char[] userid, const char[] roleid)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/members/%s/roles/%s", guildid, userid, roleid);
	SendRequest(bot, route, _, k_EHTTPMethodDELETE);
}

static void GetGuild(DiscordBot bot, const char[] guildid, bool with_counts, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s?with_counts=%s", guildid, with_counts ? "true" : "false");
	SendRequest(bot, route, _, k_EHTTPMethodGET, OnDiscordDataReceived, _, pack);
}

static void GetGuildMember(DiscordBot bot, const char[] guildid, const char[] userid, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/members/%s", guildid, userid);
	SendRequest(bot, route, _, k_EHTTPMethodGET, OnDiscordDataReceived, _, pack);
}