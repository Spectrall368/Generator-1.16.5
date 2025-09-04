<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(value = {Dist.CLIENT}) public class ${name}Procedure {
	@SubscribeEvent public static void onRightClick(PlayerInteractEvent.RightClickEmpty event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getWorld()",
				"entity": "event.getPlayer()"
			}/>
		</#compress></#assign>
		<#-- fix #5491, event is fired for both hands always, so we can filter by either -->
		if (event.getHand() != Hand.MAIN_HAND) return;
		${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}Message());
		execute(${dependenciesCode});
	}

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD)
	public static class ${name}Message {
		public ${name}Message() {}

		public ${name}Message(PacketBuffer buffer) {}

		public static void buffer(${name}Message message, PacketBuffer buffer) {}

		public static void handler(${name}Message message, Supplier<NetworkEvent.Context> contextSupplier) {
			NetworkEvent.Context context = contextSupplier.get();
			context.enqueueWork(() -> {
				if (!context.getSender().world.isBlockLoaded(context.getSender().getPosition()))
					return;
				<#assign dependenciesCode><#compress>
					<@procedureDependenciesCode dependencies, {
						"x": "context.getSender().getPosX()",
						"y": "context.getSender().getPosY()",
						"z": "context.getSender().getPosZ()",
						"world": "context.getSender().world",
						"entity": "context.getSender()"
					}/>
				</#compress></#assign>
				execute(${dependenciesCode});
			});
			context.setPacketHandled(true);
		}

		@SubscribeEvent public static void registerMessage(FMLCommonSetupEvent event) {
			${JavaModName}.addNetworkMessage(${name}Message.class, ${name}Message::buffer, ${name}Message::new, ${name}Message::handler);
		}
	}
