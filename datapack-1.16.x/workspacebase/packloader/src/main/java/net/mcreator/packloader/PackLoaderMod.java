package net.mcreator.packloader;

import net.minecraft.client.Minecraft;
import net.minecraft.resources.FolderPack;
import net.minecraft.resources.IPackNameDecorator;
import net.minecraft.resources.ResourcePackInfo;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;

import java.io.File;

@Mod(PackLoaderMod.MODID) public class PackLoaderMod {

    public static final String MODID = "packloader";

    public PackLoaderMod() {
        FMLJavaModLoadingContext.get().getModEventBus().addListener(this::addPacks);
    }

    public void addPacks(FMLClientSetupEvent event) {
        Minecraft mc = event.getMinecraftSupplier().get();
        mc.getResourcePackRepository().addPackFinder((consumer, iFactory) -> {
            if (mc.player != null)
                consumer.accept(ResourcePackInfo.create("packloader", true, () -> new FolderPack(new File("datapacks")), iFactory, ResourcePackInfo.Priority.TOP,
                        IPackNameDecorator.BUILT_IN));
        });
    }
}