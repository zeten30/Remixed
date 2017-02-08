#!/bin/bash

# -----------------------------------------------------
# Remixed themes build script
# -----------------------------------------------------
BaseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VimixGIT="https://github.com/vinceliuice/vimix-gtk-themes.git"
VimixGITdir="${BaseDir}/git/vimix-gtk-themes"

FlatRemixGIT="https://github.com/daniruiz/Flat-Remix.git"
FlatRemixGITdir="${BaseDir}/git/Flat-Remix"

RPMBuild="${BaseDir}/rpm"
RPMSources="${RPMBuild}/SOURCES/"
RPMSpecs="${RPMBuild}/SPECS/"

MockConfig="fedora-25-x86_64"

# Clone or pull repos
echo "GIT pull/clone"
echo "------------------------------------------------------------------------"

if [ -e "${VimixGITdir}" ]; then
	cd "${VimixGITdir}"
	git pull
  cd ${BaseDir}
else
	cd git/
	git clone ${VimixGIT}
  cd ${BaseDir}
fi

if [ -e "${FlatRemixGITdir}" ]; then
	cd "${FlatRemixGITdir}"
	git pull
  cd ${BaseDir}
else
	cd git/
	git clone ${FlatRemixGIT}
  cd ${BaseDir}
fi


# Clean icons & themes dir
echo -e "\nClean theme & icon folder"
echo "------------------------------------------------------------------------"

rm -rf ${BaseDir}/icons/*
rm -rf ${BaseDir}/themes/*

# Copy data
echo -e "\nCopy GIT data"
echo "------------------------------------------------------------------------"

repodir=${VimixGITdir}
srcdir=${repodir}/src
dest_dir=${BaseDir}/themes

# Tweak assets
cp ${BaseDir}/assets/* ${BaseDir}/git/vimix-gtk-themes/src/gnome-shell/assets/
cp ${BaseDir}/assets/* ${BaseDir}/git/vimix-gtk-themes/src/gnome-shell/assets-Ruby/
cp ${BaseDir}/assets/* ${BaseDir}/git/vimix-gtk-themes/src/gnome-shell/assets-Doder/


# Adjusted Vimix install script
for variant in 'Dark' 'Light' ; do
  for size in '' '-Laptop' ; do

		themedir=$dest_dir/Remixed-${variant}${size}
		install -d ${themedir}

		# Install index.theme
		cd ${srcdir}
		cp -ur \
			index-${variant}${size}.theme \
			${themedir}/index.theme

		# Install GNOME Shell Theme
		install -d ${themedir}/gnome-shell
		cd ${srcdir}/gnome-shell
		cp -ur \
			extensions \
			no-events.svg \
			no-notifications.svg \
			process-working.svg \
			${themedir}/gnome-shell

		cp -ur \
			assets \
			${themedir}/gnome-shell/assets

		cp -ur \
			gnome${variant}-shell${size}.css \
			${themedir}/gnome-shell/gnome-shell.css

		glib-compile-resources \
			--sourcedir=${themedir}/gnome-shell \
			--target=${themedir}/gnome-shell/gnome-shell-theme.gresource \
			gnome-shell-theme.gresource.xml

		# Install GTK+ 2 Theme
		install -d ${themedir}/gtk-2.0
		cd ${srcdir}/gtk-2.0

		cp -ur \
			Vimix/assets \
			Vimix/apps.rc \
			${themedir}/gtk-2.0

		cp -ur \
			Vimix/main${variant}.rc \
			${themedir}/gtk-2.0/main.rc

		cp -ur \
			Vimix/gtk${variant}rc \
			${themedir}/gtk-2.0/gtkrc

		# Install GTK+ 3 Theme
		install -d ${themedir}/gtk-3.0
		cd ${srcdir}/gtk-3.0
		cp -ur \
			assets/assets \
			${themedir}/gtk-3.0/assets
		cp -ur \
			gtk${variant}${size}.css \
			${themedir}/gtk-3.0/gtk.css
		cp -ur \
			gtk${size}-dark.css \
			${themedir}/gtk-3.0/gtk-dark.css

		# Install Metacity Theme
		install -d ${themedir}/metacity-1
		cd ${srcdir}/metacity-1/Vimix${variant}
		cp -ur \
			*.svg \
			${themedir}/metacity-1

		cp -ur \
			metacity-theme-2.xml \
			${themedir}/metacity-1/metacity-theme-2.xml
		cp -ur \
			metacity-theme-3.xml \
			${themedir}/metacity-1/metacity-theme-3.xml


		# Install Unity Theme
		install -d ${themedir}/unity
		cd ${srcdir}/unity
		cp -ur \
			Vimix${size}/* \
			${themedir}/unity

  done
done


# Icons
cp -ur ${FlatRemixGITdir}/'Flat Remix' ${BaseDir}/icons/Remixed-Light
cp -ur ${FlatRemixGITdir}/'Flat Remix' ${BaseDir}/icons/Remixed-Dark


# Clean
echo -e "\nOverride folder icons"
echo "------------------------------------------------------------------------"

rm -rf ${BaseDir}/icons/Remixed-Dark/places/scalable
rm -rf ${BaseDir}/icons/Remixed-Light/places/scalable

# Overide folders
cp -fru ${BaseDir}/icons-places/Dark ${BaseDir}/icons/Remixed-Dark/places/scalable
cp -fru ${BaseDir}/icons-places/Light ${BaseDir}/icons/Remixed-Light/places/scalable


# Font replacement for gnome-shell themes
echo -e "\nFonts replacement"
echo "------------------------------------------------------------------------"

sed -i 's/"M+ 1c", Roboto, Cantarell, Sans-Serif/"Source Sans Pro", Sans-Serif/g' ${BaseDir}/themes/Remixed*/gnome-shell/gnome-shell.css
sed -i 's/font-size: 9.75pt;/font-size: 10pt;/g' ${BaseDir}/themes/Remixed*Laptop/gnome-shell/gnome-shell.css
sed -i 's/font-size: 10.5pt;/font-size: 11pt;/g' ${BaseDir}/themes/Remixed-Dark/gnome-shell/gnome-shell.css
sed -i 's/font-size: 10.5pt;/font-size: 11pt;/g' ${BaseDir}/themes/Remixed-Light/gnome-shell/gnome-shell.css

# Fix theme index files
echo -e "\nTheme index fix"
echo "------------------------------------------------------------------------"

sed -i 's/Vimix/Remixed-/g' ${BaseDir}/themes/Remixed*/index.theme
sed -i 's/Flat Remix/Remixed-Light/g' ${BaseDir}/icons/Remixed-Light/index.theme
sed -i 's/Flat Remix/Remixed-Dark/g' ${BaseDir}/icons/Remixed-Dark/index.theme


# RPM build prepare
echo -e "\nBuild sources for RPM"
echo "------------------------------------------------------------------------"

#ICONS
cd ${BaseDir}
tar czf remixed-icons.tar.gz icons
mv remixed-icons.tar.gz ${RPMSources}

#THEMES
cd ${BaseDir}
tar czf remixed-themes.tar.gz themes
mv remixed-themes.tar.gz ${RPMSources}

#Terminix
cd ${BaseDir}
tar cfz remixed-terminix-scheme.tar.gz terminix/
mv ${BaseDir}/remixed-terminix-scheme.tar.gz ${RPMSources}

#SPECS
rm -rf ${RPMSpecs}/*.*
cp ${BaseDir}/*.spec  ${RPMSpecs}


# RPM build
echo -e "\nBuild SPRMS"
echo "------------------------------------------------------------------------"

rm -rf ${RPMBuild}/SRPMS/*.rpm ${RPMBuild}/SRPMS/*.log

cd ${RPMBuild}
mock -r ${MockConfig} --spec=SPECS/remixed-themes.spec --sources=SOURCES/ --resultdir=SRPMS/ --buildsrpm
mock -r ${MockConfig} --spec=SPECS/remixed-icons.spec --sources=SOURCES/ --resultdir=SRPMS/ --buildsrpm
mock -r ${MockConfig} --spec=SPECS/remixed-terminix-scheme.spec --sources=SOURCES/ --resultdir=SRPMS/ --buildsrpm

cd ${BaseDir}

echo -e "\nDONE :)"
