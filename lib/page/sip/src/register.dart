import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class RegisterWidget extends StatefulWidget {
  final SIPUAHelper? _helper;

  const RegisterWidget(this._helper, {Key? key}) : super(key: key);

  @override
  _MyRegisterWidget createState() {
    return _MyRegisterWidget();
  }
}

class _MyRegisterWidget extends State<RegisterWidget>
    implements SipUaHelperListener {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _wsUriController = TextEditingController();
  final TextEditingController _sipUriController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _authorizationUserController = TextEditingController();
  final Map<String, String> _wsExtraHeaders = {};
  late SharedPreferences _preferences;
  late RegistrationState _registerState;

  SIPUAHelper? get helper => widget._helper;

  @override
  initState() {
    super.initState();
    
    _registerState = helper!.registerState;
    debugPrint('RegisterWidget initState ${_registerState.state}');
    helper!.addSipUaHelperListener(this);
    _loadSettings();

      
  }

  @override
  deactivate() {
    super.deactivate();
    helper!.removeSipUaHelperListener(this);
    super.dispose();
    _saveSettings();
  }

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _wsUriController.text = _preferences.getString('ws_uri') ?? '';
      _sipUriController.text = _preferences.getString('sip_uri') ?? '';
      _displayNameController.text = _preferences.getString('display_name') ?? '';
      _passwordController.text = _preferences.getString('password') ?? '';
      _authorizationUserController.text = _preferences.getString('auth_user') ?? '';
    });
  }

  void _saveSettings() {
    _preferences.setString('ws_uri', _wsUriController.text);
    _preferences.setString('sip_uri', _sipUriController.text);
    _preferences.setString('display_name', _displayNameController.text);
    _preferences.setString('password', _passwordController.text);
    _preferences.setString('auth_user', _authorizationUserController.text);
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {
      _registerState = state;
    });
  }

  void _alert(BuildContext context, String alertFieldName) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('$alertFieldName is empty'),
          content: Text('Please enter $alertFieldName!'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSave(BuildContext context) {
    if (_wsUriController.text == '') {
      _alert(context, "WebSocket URL");
    } else if (_sipUriController.text == '') {
      _alert(context, "SIP URI");
    }

    UaSettings settings = UaSettings();

    settings.webSocketUrl = _wsUriController.text;
    settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
    settings.webSocketSettings.allowBadCertificate = true;
    settings.uri = _sipUriController.text;
    settings.authorizationUser = _authorizationUserController.text;
    settings.password = _passwordController.text;
    settings.displayName = _displayNameController.text;
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;

    helper!.start(settings);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("SIP Account"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Register Status: ${EnumHelper.getName(_registerState.state)}',
                style: const TextStyle(fontSize: 18, color: CupertinoColors.black),
              ),
              const SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _wsUriController,
                placeholder: 'WebSocket URL',
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _sipUriController,
                placeholder: 'SIP URI',
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _authorizationUserController,
                placeholder: 'Authorization User',
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _displayNameController,
                placeholder: 'Display Name',
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 16.0),
              CupertinoButton.filled(
                onPressed: () => _handleSave(context),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void callStateChanged(Call call, CallState state) {
    //NO OP
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // NO OP
  }

  @override
  void onNewNotify(Notify ntf) {
    // NO OP
  }
}
