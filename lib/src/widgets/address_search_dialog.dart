part of 'package:address_search_field/address_search_field.dart';

/// Callback method.
typedef OnDoneCallback = FutureOr<void> Function(Address address);

/// Permits to build an [_AddressSearchDialog] by default from an [AddressSearchBuilder].
class AddressDialogBuilder {
  /// Constructor for [_AddressSearchDialog].
  AddressDialogBuilder({
    this.color,
    this.backgroundColor = Colors.white,
    this.hintText = 'Address or reference',
    this.noResultsText = "There're no results",
    this.cancelText = 'Cancel',
    this.continueText = 'Continue',
    this.useButtons = true,
  });

  /// Color for details in the widget.
  final Color? color;

  /// Bakcground color for widget.
  final Color backgroundColor;

  /// Message to show when the [TextField] of the widget is empty.
  final String hintText;

  /// Message to show when the [ListView] of the widget is empty.
  final String noResultsText;

  /// Text for [ElevatedButton] of the widget to cancel.
  final String cancelText;

  /// Text for [ElevatedButton] of the widget to continue.
  final String continueText;

  /// Sets if the [AddressDialog] will have buttons at bottom.
  final bool useButtons;
}

/// Default [Dialog] to search [Address].
class _AddressSearchDialog extends StatelessWidget {
  /// Constructor for [AddressSearchDialog].
  const _AddressSearchDialog({
    required this.snapshot,
    required this.controller,
    required this.searchAddress,
    required this.getGeometry,
    this.color,
    this.backgroundColor = Colors.white,
    this.hintText = 'Address or reference',
    this.noResultsText = "There're no results",
    this.cancelText = 'Cancel',
    this.continueText = 'Continue',
    this.useButtons = true,
    required this.onDone,
  })  : this._addrComm = null,
        this._addressId = null;

  /// Constructor for [AddressSearchDialog] to be called by [AddressSearchBuilder].
  const _AddressSearchDialog._fromBuilder(
    this.snapshot,
    this.controller,
    this.searchAddress,
    this.getGeometry,
    this.color,
    this.backgroundColor,
    this.hintText,
    this.noResultsText,
    this.cancelText,
    this.continueText,
    this.useButtons,
    this.onDone,
    this._addrComm,
    this._addressId,
  );

  /// Representation of the most recent interaction with an asynchronous computation.
  final AsyncSnapshot<List<Address>> snapshot;

  /// controller for text used to search an [Address].
  final TextEditingController controller;

  /// Loads a list of found addresses by the text in [widget.controller].
  final SearchAddressCallback searchAddress;

  /// Tries to get a completed [Address] object by a reference or place id.
  final GetGeometryCallback getGeometry;

  /// Color for details in the widget.
  final Color? color;

  /// Bakcground color for widget.
  final Color backgroundColor;

  /// Message to show when the [TextField] of the widget is empty.
  final String hintText;

  /// Message to show when the [ListView] of the widget is empty.
  final String noResultsText;

  /// Text for [ElevatedButton] of the widget to cancel.
  final String cancelText;

  /// Text for [ElevatedButton] of the widget to continue.
  final String continueText;

  /// Sets if the [AddressDialog] will have buttons at bottom.
  final bool useButtons;

  /// Variable for [AddressDialog].
  final OnDoneCallback onDone;

  /// Identifies the [Address] to work in the [Widget] built.
  final AddressId? _addressId;

  /// Permits to work with the found [Address] by a [RouteSearchBox].
  final _AddrComm? _addrComm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size =
            Size(constraints.constrainWidth(), constraints.constrainHeight());
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _searchBar(context, size),
                SizedBox(
                  width: size.width * 0.8,
                  child: Divider(
                    color: Colors.grey,
                    height: 0.2,
                  ),
                ),
                _resultsList(context, size),
                (useButtons)
                    ? SizedBox(
                        width: size.width * 0.8,
                        child: Divider(color: Colors.grey, height: 0.2),
                      )
                    : Container(),
                (useButtons) ? _dialogButtons(context, size) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Bar to write a reference and search an [Address].
  Widget _searchBar(BuildContext context, Size size) => Container(
        height: 55.0,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: (size.width * 0.8) * 0.03125), // 0.03125
              child: Icon(
                Icons.location_city,
                // size: (size.width * 0.8) * 0.0625,
              ),
            ),
            SizedBox(
              width: (size.width * 0.8) * 0.72,
              child: TextField(
                controller: controller,
                autofocus: true,
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                cursorColor: color ?? Theme.of(context).primaryColor,
                onEditingComplete: searchAddress,
                decoration: InputDecoration(
                  suffix: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 13.0,
                      ),
                    ),
                    onTap: controller.clear,
                  ),
                  hintText: hintText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: color ?? Theme.of(context).primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: color ?? Theme.of(context).primaryColor),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: color ?? Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(
                    right: (size.width * 0.8) * 0.0425), // 0.03125
                child: Icon(
                  Icons.search_rounded,
                  color: color ?? Theme.of(context).primaryColor,
                  // size: (size.width * 0.8) * 0.0625,
                ),
              ),
              onTap: searchAddress,
            )
          ],
        ),
      );

  /// Resulted list of [Address] from searching.
  Widget _resultsList(BuildContext context, Size size) => Container(
        height: size.height * 0.35,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: (useButtons)
              ? BorderRadius.all(Radius.zero)
              : BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
        ),
        child: Center(
          child: (snapshot.connectionState == ConnectionState.waiting)
              ? CircularProgressIndicator()
              : (snapshot.hasData)
                  ? ListView.separated(
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        title: Text(snapshot.data![index].reference!),
                        onTap: () async => await _selected(
                          context,
                          await (getGeometry(snapshot.data![index])),
                        ),
                      ),
                    )
                  : Text(noResultsText,
                      style: TextStyle(color: Colors.grey.shade500)),
        ),
      );

  /// Buttons to close or continue.
  Widget _dialogButtons(BuildContext context, Size size) => Container(
        height: 45,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                child: Text(
                  cancelText,
                  style:
                      TextStyle(color: color ?? Theme.of(context).primaryColor),
                ),
                onTap: () => _dismiss(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Text(
                  continueText,
                  style:
                      TextStyle(color: color ?? Theme.of(context).primaryColor),
                ),
                onTap: () async => await _selected(
                  context,
                  Address(reference: controller.text),
                ),
              ),
            ),
          ],
        ),
      );

  /// Closes itself.
  void _dismiss(BuildContext context) {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  /// Selects an [Address] to work.
  Future<void> _selected(BuildContext context, Address address) async {
    if (controller.text != address.reference)
      controller.text = address.reference!;
    if (_addrComm != null && _addressId != null)
      _addrComm!.writeAddr(_addressId!, address);
    await onDone(address);
    _dismiss(context);
  }
}
