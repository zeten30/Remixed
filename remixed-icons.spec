Name:		Remixed-icons
Version:	1.0
Release:	1%{?dist}
Summary:	Remix of my favourite icon themes
Group:		User Interface/Desktops
License:	GPL-3
URL:		https://github.com/zeten30/Remixed
Vendor:		Milan Zink <zeten30@gmail.com>
Source0:	remixed-icons.tar.gz
BuildArch:	noarch

%description
Remixed-icon-theme is a remix of my icon theme Super Flat

%prep
%setup -q -n icons

%build
# Nothing to build

%install
%{__install} -d -m755 %{buildroot}%{_datadir}/icons/
for file in Remixed-Light Remixed-Dark; do
  %{__cp} -pr ${file} %{buildroot}%{_datadir}/icons
done

%files
%defattr(-,root,root)
%{_datadir}/icons/Remixed-Light
%{_datadir}/icons/Remixed-Dark

%changelog
* Thu Feb 2 2017 Milan Zink <zeten30@gmail.com> - 1.0.1
- Initial build
