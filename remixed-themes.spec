Name:		Remixed-themes
Version:	1.0
Release:	2%{?dist}
Summary:	Remix of Arc GTK2/3 themes
Group:		User Interface/Desktops
License:	GPL-3
URL:		https://github.com/zeten30/Remixed
Vendor:		Milan Zink <zeten30@gmail.com>
Source0:	remixed-themes.tar.gz
Requires: 	gtk-murrine-engine gtk2-engines adobe-source-sans-pro-fonts adobe-source-code-pro-fonts
BuildArch:	noarch

%description
Remixed-theme is a remix of my favourite GTK2/3 theme Vimix-* and customized Vimix gnome-shell theme

%prep
%setup -q -n themes

%build
# Nothing to build

%install
%{__install} -d -m755 %{buildroot}%{_datadir}/themes/
for file in Remixed-Light Remixed-Dark Remixed-Light-Laptop Remixed-Dark-Laptop; do
	%{__cp} -pr ${file} %{buildroot}%{_datadir}/themes
done

%files
%defattr(-,root,root)
%{_datadir}/themes/Remixed-Light
%{_datadir}/themes/Remixed-Dark
%{_datadir}/themes/Remixed-Light-Laptop
%{_datadir}/themes/Remixed-Dark-Laptop

%changelog
* Wed Feb 8 2017 Milan Zink <zeten30@gmail.com> - 1.0.2
- Gnome shell theme tweaks

* Thu Feb 2 2017 Milan Zink <zeten30@gmail.com> - 1.0.1
- Initial package for Fedora
