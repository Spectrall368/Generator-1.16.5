<#-- @formatter:off -->
/*
 *    MCreator note:
 *
 *    This file is autogenerated to connect all MCreator mod elements together.
 *
 */
package ${package};

import ${package}.${JavaModName};

import net.minecraftforge.fml.ModList;
import java.util.Map;

public class ${JavaModName}Elements {

	public final List<ModElement> elements = new ArrayList<>();

	<#if w.hasElementsOfBaseType("block")>
	public final List<Supplier<Block>> blocks = new ArrayList<>();
	</#if>
	<#if w.hasElementsOfBaseType("item")>
	public final List<Supplier<Item>> items = new ArrayList<>();
	</#if>
	<#if w.hasElementsOfBaseType("entity")>
	public final List<Supplier<EntityType<?>>> entities = new ArrayList<>();
	</#if>
	<#if w.hasElementsOfType("enchantment")>
	public final List<Supplier<Enchantment>> enchantments = new ArrayList<>();
	</#if>

	public static Map<ResourceLocation, net.minecraft.util.SoundEvent> sounds = new HashMap<>();

	public ${JavaModName}Elements () {
		<#list sounds as sound>
		sounds.put(new ResourceLocation("${modid}" ,"${sound}"), new net.minecraft.util.SoundEvent(new ResourceLocation("${modid}" ,"${sound}")));
		</#list>

		try {
			ModFileScanData modFileInfo = ModList.get().getModFileById("${modid}").getFile().getScanResult();
			Set<ModFileScanData.AnnotationData> annotations = modFileInfo.getAnnotations();
			for (ModFileScanData.AnnotationData annotationData : annotations) {
				if (annotationData.getAnnotationType().	getClassName().equals(ModElement.Tag.class.getName())) {
					Class<?> clazz = Class.forName(annotationData.getClassType().getClassName());
					if(clazz.getSuperclass() == ${JavaModName}Elements.ModElement.class)
						elements.add((${JavaModName}Elements.ModElement) clazz.getConstructor(this.getClass()).newInstance(this));
					}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		Collections.sort(elements);
		elements.forEach(${JavaModName}Elements.ModElement::initElements);

		<#if w.hasVariables()>
		MinecraftForge.EVENT_BUS.register(new ${JavaModName}Variables(this));
		</#if>
	}

	public void registerSounds(RegistryEvent.Register<net.minecraft.util.SoundEvent> event) {
		for (Map.Entry<ResourceLocation, net.minecraft.util.SoundEvent> sound : sounds.entrySet())
			event.getRegistry().register(sound.getValue().setRegistryName(sound.getKey()));
	}

	private int messageID = 0;

	public <T> void addNetworkMessage(Class<T> messageType, BiConsumer<T, PacketBuffer> encoder, Function<PacketBuffer, T> decoder,
			BiConsumer<T, Supplier<NetworkEvent.Context>> messageConsumer) {
		${JavaModName}.PACKET_HANDLER.registerMessage(messageID, messageType, encoder, decoder, messageConsumer);
		messageID++;
	}

	public List<ModElement> getElements() {
		return elements;
	}

	<#if w.hasElementsOfBaseType("block")>
	public List<Supplier<Block>> getBlocks() {
		return blocks;
	}
	</#if>

	<#if w.hasElementsOfBaseType("item")>
	public List<Supplier<Item>> getItems() {
		return items;
	}
	</#if>

	<#if w.hasElementsOfBaseType("entity")>
	public List<Supplier<EntityType<?>>> getEntities() {
		return entities;
	}
	</#if>

	<#if w.hasElementsOfType("enchantment")>
	public List<Supplier<Enchantment>> getEnchantments() {
		return enchantments;
	}
	</#if>

	public static class ModElement implements Comparable<ModElement> {

		@Retention(RetentionPolicy.RUNTIME)
		public @interface Tag { }

		protected final ${JavaModName}Elements elements;
		protected final int sortid;

		public ModElement(${JavaModName}Elements elements, int sortid) {
			this.elements = elements;
			this.sortid = sortid;
		}

		public void initElements() {
		}

		public void init(FMLCommonSetupEvent event) {
		}

		public void serverLoad(FMLServerStartingEvent event) {
		}

		@OnlyIn(Dist.CLIENT) public void clientLoad(FMLClientSetupEvent event) {
		}

		@Override public int compareTo(ModElement other) {
        		return this.sortid - other.sortid;
    		}
	}
}
<#-- @formatter:on -->
