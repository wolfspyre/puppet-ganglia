Name            : Murmur
Version         : 1.2.3
Release         : 1
Summary         : Murmur Server
Group           : System Environment/Daemons
Source0         : murmur-1.2.3.tar.gz
Source1         : murmur.init
URL             : http://mumble.sourceforge.net
Vendor          : http://sourceforge.net/apps/phpbb/mumble/
License         : GPLv2
Packager        : Wolf Noble
BuildArch       : x86_64
BuildRoot       : %{_tmppath}/%{name}-%{version}-root
Requires        : glibc
Requires(pre)   : shadow-utils
AutoReq		: 0
 
%description
Mumble is a voice chat application for groups. While it can be used for any kind of activity, it is primarily intended for gaming. It can be compared to programs like Ventrilo or TeamSpeak. People tend to simplify things, so when they talk about Mumble they either talk about "Mumble" the client application or about "Mumble & Murmur" the whole voice chat application suite
 
%prep
mkdir -p $RPM_BUILD_ROOT/usr/local/
mkdir -p $RPM_BUILD_ROOT%{_localstatedir}/log
%build
cd   $RPM_BUILD_ROOT/usr/local/
zcat $RPM_SOURCE_DIR/murmur-1.2.3.tar.gz | tar -xvf -
%install
touch             $RPM_BUILD_ROOT%{_localstatedir}/log/murmur.log 
install -d -m 755 %{buildroot}%{_initrddir}
install -p -m 755 %{SOURCE1} %{buildroot}%{_initrddir}/murmur
touch             $RPM_BUILD_ROOT/usr/local/murmur/murmur.sqlite
 
%clean
rm -rf %{buildroot}
 
%files
%defattr(-,root,root)
%dir %{_initrddir}/murmur
%dir /usr/local/murmur
%attr(-,murmur,murmur) /usr/local/murmur
%attr(-,murmur,murmur) /var/log/murmur.log
%config /usr/local/murmur/murmur.ini
%ghost  /usr/local/murmur/murmur.sqlite
%ghost  /var/log/murmur.log
 
%pre
/usr/bin/getent group murmur >/dev/null || /usr/sbin/groupadd -g 401 murmur
/usr/bin/getent passwd murmur >/dev/null || \
    /usr/sbin/useradd -r -u 401 -g murmur -d /usr/local/murmur -s /dev/null -c "Murmur Daemon" murmur
exit 0
 
%post

%postun
if [ "$1" == "0" ]; then
   userdel --force murmur 2> /dev/null; true
fi
 
%changelog
* Thu Dec 27 2012 Wolf Noble
- initial creation
