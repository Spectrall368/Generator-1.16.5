<#-- @formatter:off -->
package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Mod("${modid}") public class ${JavaModName} {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	public ${JavaModName}() {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		MinecraftForge.EVENT_BUS.register(new ${JavaModName}FMLBusEvents(this));

		IEventBus bus = FMLJavaModLoadingContext.get().getModEventBus();
		<#if w.hasElementsOfType("tab")>${JavaModName}Tabs.load();</#if>
		<#if w.hasSounds()>${JavaModName}Sounds.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("block")>${JavaModName}Blocks.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("item")>${JavaModName}Items.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("entity")>${JavaModName}Entities.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("blockentity")>${JavaModName}BlockEntities.REGISTRY.register(bus);</#if>
		<#if w.getGElementsOfType("block")?filter(e -> e.generateFeature )?size != 0 || w.getGElementsOfType("plant")?filter(e -> e.generateFeature )?size != 0 || w.hasElementsOfType("feature")>${JavaModName}Features.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("fluid")>${JavaModName}Fluids.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("painting")>${JavaModName}Paintings.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("potioneffect")>${JavaModName}MobEffects.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("potion")>${JavaModName}Potions.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("enchantment")>${JavaModName}Enchantments.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("particle")>${JavaModName}ParticleTypes.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("structure")>${JavaModName}Structures.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("gui")>${JavaModName}Menus.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("biome")>${JavaModName}Biomes.REGISTRY.register(bus);</#if>
		<#if w.getElementsOfType("feature")?filter(e -> e.getMetadata("has_nbt_structure")??)?size != 0>StructureModFeature.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("villagerprofession")>${JavaModName}VillagerProfessions.PROFESSIONS.register(bus);</#if>
		<#if w.hasElementsOfType("attribute")>${JavaModName}Attributes.REGISTRY.register(bus);</#if>
		bus.register(this);

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods

	private static final String PROTOCOL_VERSION = "1";
	public static final SimpleChannel PACKET_HANDLER = NetworkRegistry.newSimpleChannel(
			new ResourceLocation(MODID, MODID),
			() -> PROTOCOL_VERSION,
			PROTOCOL_VERSION::equals,
			<#if settings.isServerSideOnly()>clientVersion -> true<#else>PROTOCOL_VERSION::equals</#if>
	);

	private static int messageID = 0;

	public static <T> void addNetworkMessage(Class<T> messageType, BiConsumer<T, PacketBuffer> encoder, Function<PacketBuffer, T> decoder, BiConsumer<T, Supplier<NetworkEvent.Context>> messageConsumer) {
		PACKET_HANDLER.registerMessage(messageID, messageType, encoder, decoder, messageConsumer);
		messageID++;
	}

	private static final Collection<AbstractMap.SimpleEntry<Runnable, Integer>> workQueue = new ConcurrentLinkedQueue<>();

	public static void queueServerWork(int tick, Runnable action) {
		if (Thread.currentThread().getThreadGroup() == SidedThreadGroups.SERVER)
			workQueue.add(new AbstractMap.SimpleEntry<>(action, tick));
	}

	private static class ${JavaModName}FMLBusEvents {
		private final ${JavaModName} parent;

		${JavaModName}FMLBusEvents (${JavaModName} parent) {
			this.parent = parent;
		}

		@SubscribeEvent public void tick(TickEvent.ServerTickEvent event) {
			if (event.phase == TickEvent.Phase.END) {
				List<AbstractMap.SimpleEntry<Runnable, Integer>> actions = new ArrayList<>();
				workQueue.forEach(work -> {
					work.setValue(work.getValue() - 1);
					if (work.getValue() == 0)
						actions.add(work);
				});
				actions.forEach(e -> e.getKey().run());
				workQueue.removeAll(actions);
			}
		}
	}
}
<#-- @formatter:on -->
