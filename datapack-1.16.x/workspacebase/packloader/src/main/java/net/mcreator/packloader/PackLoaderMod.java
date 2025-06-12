package net.mcreator.packloader;

import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.event.AddPackFindersEvent;

import net.minecraft.server.packs.repository.PackSource;
import net.minecraft.server.packs.repository.FolderRepositorySource;

import java.io.File;

@Mod(PackLoaderMod.MODID) public class PackLoaderMod {

	public static final String MODID = "packloader";

	public PackLoaderMod() {
		FMLJavaModLoadingContext.get().getModEventBus().addListener(this::addPacks);
	}

	public void addPacks(AddPackFindersEvent event) {
		event.addRepositorySource(new FolderRepositorySource(new File("datapacks"), PackSource.DEFAULT));
	}

}
