<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			${JavaModName}.addNetworkMessage(SavedDataSyncMessage.class, SavedDataSyncMessage::buffer, SavedDataSyncMessage::new, SavedDataSyncMessage::handleData);
		</#if>

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
			CapabilityManager.INSTANCE.register(PlayerVariables.class, new PlayerVariablesStorage(), PlayerVariables::new);
			${JavaModName}.addNetworkMessage(PlayerVariablesSyncMessage.class, PlayerVariablesSyncMessage::buffer, PlayerVariablesSyncMessage::new, PlayerVariablesSyncMessage::handleData);
		</#if>
	}

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP") || w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
    @Mod.EventBusSubscriber public static class EventBusVariableHandlers {
		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
        @SubscribeEvent public static void onPlayerLoggedInSyncPlayerVariables(PlayerEvent.PlayerLoggedInEvent event) {
            if (event.getEntity() instanceof ServerPlayerEntity)
                ((ServerPlayerEntity) event.getEntity()).getCapability(PLAYER_VARIABLES).ifPresent(capability -> ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.getEntity()), new PlayerVariablesSyncMessage(capability)));
        }

        @SubscribeEvent public static void onPlayerRespawnedSyncPlayerVariables(PlayerEvent.PlayerRespawnEvent event) {
            if (event.getEntity() instanceof ServerPlayerEntity)
                ((ServerPlayerEntity) event.getEntity()).getCapability(PLAYER_VARIABLES).ifPresent(capability -> ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.getEntity()), new PlayerVariablesSyncMessage(capability)));
        }

        @SubscribeEvent public static void onPlayerChangedDimensionSyncPlayerVariables(PlayerEvent.PlayerChangedDimensionEvent event) {
            if (event.getEntity() instanceof ServerPlayerEntity)
                ((ServerPlayerEntity) event.getEntity()).getCapability(PLAYER_VARIABLES).ifPresent(capability -> ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.getEntity()), new PlayerVariablesSyncMessage(capability)));
        }

        @SubscribeEvent public static void onPlayerTickUpdateSyncPlayerVariables(TickEvent.PlayerTickEvent event) {
            if (event.phase == TickEvent.Phase.END && event.player instanceof ServerPlayerEntity) {
                ((ServerPlayerEntity) event.player).getCapability(PLAYER_VARIABLES).ifPresent(capability -> {
                    if (capability._syncDirty) {
                        ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.player), new PlayerVariablesSyncMessage(capability));
                        capability._syncDirty = false;
                    }
                });
            }
        }

        @SubscribeEvent public static void clonePlayer(PlayerEvent.Clone event) {
		    event.getOriginal().revive();

		    event.getOriginal().getCapability(PLAYER_VARIABLES).ifPresent(original -> {
		        event.getEntity().getCapability(PLAYER_VARIABLES).ifPresent(clone -> {
                    <#list variables as var>
                        <#if var.getScope().name() == "PLAYER_PERSISTENT">
                        clone.${var.getName()} = original.${var.getName()};
                        </#if>
                    </#list>
                    if(!event.isWasDeath()) {
                        <#list variables as var>
                            <#if var.getScope().name() == "PLAYER_LIFETIME">
                            clone.${var.getName()} = original.${var.getName()};
                            </#if>
                        </#list>
                    }
		        });
		    });
        }
        </#if>

        <#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
        @SubscribeEvent public static void onPlayerLoggedIn(PlayerEvent.PlayerLoggedInEvent event) {
            if (event.getEntity() instanceof ServerPlayerEntity) {
                WorldSavedData mapdata = MapVariables.get(((ServerPlayerEntity) event.getEntity()).world);
                WorldSavedData worlddata = WorldVariables.get(((ServerPlayerEntity) event.getEntity()).world);
                if(mapdata != null)
                    ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.getEntity()), new SavedDataSyncMessage(0, mapdata));
                if(worlddata != null)
                    ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.getEntity()), new SavedDataSyncMessage(1, worlddata));
            }
        }

        @SubscribeEvent public static void onPlayerChangedDimension(PlayerEvent.PlayerChangedDimensionEvent event) {
            if (event.getEntity() instanceof ServerPlayerEntity) {
                WorldSavedData worlddata = WorldVariables.get(((ServerPlayerEntity) event.getEntity()).world);
                if(worlddata != null)
                    ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> (ServerPlayerEntity) event.getEntity()), new SavedDataSyncMessage(1, worlddata));
            }
        }

        @SubscribeEvent public static void onWorldTick(TickEvent.WorldTickEvent event) {
            if (event.phase == TickEvent.Phase.END && event.world instanceof ServerWorld) {
                WorldVariables worldVariables = WorldVariables.get((ServerWorld) event.world);
                if (worldVariables._syncDirty) {
                    ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.DIMENSION.with(((ServerWorld) event.world).dimension::getType), new SavedDataSyncMessage(1, worldVariables));
                    worldVariables._syncDirty = false;
                }

                MapVariables mapVariables = MapVariables.get((ServerWorld) event.world);
                if (mapVariables._syncDirty) {
                    ${JavaModName}.PACKET_HANDLER.send(PacketDistributor.ALL.noArg(), new SavedDataSyncMessage(0, mapVariables));
                    mapVariables._syncDirty = false;
                }
            }
        }
		</#if>
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends WorldSavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public WorldVariables() {
			super(DATA_NAME);
		}

		public WorldVariables(String s) {
			super(s);
		}

		@Override public void read(CompoundNBT nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundNBT write(CompoundNBT nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.markDirty();
			this._syncDirty = true;
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(IWorld world) {
			if (world instanceof ServerWorld) {
				return ((ServerWorld) world).getSavedData().getOrCreate(WorldVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class MapVariables extends WorldSavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public MapVariables() {
			super(DATA_NAME);
		}

		public MapVariables(String s) {
			super(s);
		}

		@Override public void read(CompoundNBT nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundNBT write(CompoundNBT nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.markDirty();
			_syncDirty = true;
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(IWorld world) {
			if (world instanceof IServerWorld) {
				return ((IServerWorld) world).getWorld().getServer().getWorld(World.OVERWORLD).getSavedData().getOrCreate(MapVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class SavedDataSyncMessage {
		private final int dataType;
		private final WorldSavedData data;

		public SavedDataSyncMessage(int dataType, WorldSavedData data) {
			this.dataType = dataType;
			this.data = data;
		}

		public SavedDataSyncMessage(PacketBuffer buffer) {
		    int dataType = buffer.readInt();
		    CompoundNBT nbt = buffer.readCompoundTag();
		    WorldSavedData data = null;
		    if (nbt != null) {
		        data = dataType == 0 ? new MapVariables() : new WorldVariables();
		        if(data instanceof MapVariables)
		            ((MapVariables) data).read(nbt);
		        else if(data instanceof WorldVariables)
		            ((WorldVariables) data).read(nbt);
		    }

		    this.dataType = dataType;
		    this.data = data;
		}

		public static void buffer(SavedDataSyncMessage message, PacketBuffer buffer) {
		    buffer.writeInt(message.dataType);
		    if (message.data != null)
		        buffer.writeCompoundTag(message.data.write(new CompoundNBT()));
		}

		public static void handleData(final SavedDataSyncMessage message, final Supplier<NetworkEvent.Context> contextSupplier) {
			NetworkEvent.Context context = contextSupplier.get();
			context.enqueueWork(() -> {
			    if (!context.getDirection().getReceptionSide().isServer() && message.data != null) {
					if (message.dataType == 0)
						MapVariables.clientSide.read(message.data.write(new CompoundNBT()));
					else
						WorldVariables.clientSide.read(message.data.write(new CompoundNBT()));
				}
			});
			context.setPacketHandled(true);
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	@CapabilityInject(PlayerVariables.class) public static Capability<PlayerVariables> PLAYER_VARIABLES = null;

	@Mod.EventBusSubscriber private static class PlayerVariablesProvider implements ICapabilitySerializable<INBT> {
		@SubscribeEvent public static void onAttachCapabilities(AttachCapabilitiesEvent<Entity> event) {
			if (event.getObject() instanceof PlayerEntity && !(event.getObject() instanceof FakePlayer))
				event.addCapability(new ResourceLocation("${modid}", "player_variables"), new PlayerVariablesProvider());
		}

		private final LazyOptional<PlayerVariables> instance = LazyOptional.of(PLAYER_VARIABLES::getDefaultInstance);

		@Override public <T> LazyOptional<T> getCapability(Capability<T> cap, Direction side) {
			return cap == PLAYER_VARIABLES ? instance.cast() : LazyOptional.empty();
		}

		@Override public INBT serializeNBT() {
			return PLAYER_VARIABLES.writeNBT(this.instance.orElseThrow(RuntimeException::new), null);
		}

		@Override public void deserializeNBT(INBT nbt) {
			PLAYER_VARIABLES.readNBT(this.instance.orElseThrow(RuntimeException::new), null, nbt);
		}
	}

	public static class PlayerVariables implements INBTSerializable<CompoundNBT> {

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		@Override public CompoundNBT serializeNBT() {
			CompoundNBT nbt = new CompoundNBT();
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		@Override public void deserializeNBT(CompoundNBT nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

		public void markSyncDirty() {
			_syncDirty = true;
		}
	}

	private static class PlayerVariablesStorage implements Capability.IStorage<PlayerVariables> {
		@Override public INBT writeNBT(Capability<PlayerVariables> capability, PlayerVariables instance, Direction side) {
			return instance.serializeNBT();
		}

		@Override public void readNBT(Capability<PlayerVariables> capability, PlayerVariables instance, Direction side, INBT inbt) {
			instance.deserializeNBT((CompoundNBT) inbt);
		}
	}

	public static class PlayerVariablesSyncMessage {
	    private static final PlayerVariablesStorage playerStorage = new PlayerVariablesStorage();
	    private final PlayerVariables data;

	    public PlayerVariablesSyncMessage(PlayerVariables data) {
	        this.data = data;
	    }

		public PlayerVariablesSyncMessage(PacketBuffer buffer) {
			this(new PlayerVariables());
			playerStorage.readNBT(null, this.data, null, buffer.readCompoundTag());
		}

		public PlayerVariables data() {
		    return data;
		}

		public static void buffer(PlayerVariablesSyncMessage message, PacketBuffer buffer) {
			buffer.writeCompoundTag((CompoundNBT) playerStorage.writeNBT(null, message.data(), null));
		}

		public static void handleData(final PlayerVariablesSyncMessage message, final Supplier<NetworkEvent.Context> contextSupplier) {
			NetworkEvent.Context context = contextSupplier.get();
			context.enqueueWork(() -> {
				if (!context.getDirection().getReceptionSide().isServer() && message.data != null)
					Minecraft.getInstance().player.getCapability(PLAYER_VARIABLES).ifPresent(cap -> {
					<#list variables as var>
						<#if var.getScope().name() == "PLAYER_LIFETIME" || var.getScope().name() == "PLAYER_PERSISTENT">
						cap.${var.getName()} = message.data().${var.getName()};
						</#if>
					</#list>
					});
			});
			context.setPacketHandled(true);
		}
	}
	</#if>
}
<#-- @formatter:on -->