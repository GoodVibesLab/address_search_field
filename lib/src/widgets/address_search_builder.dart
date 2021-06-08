part of 'package:address_search_field/address_search_field.dart';

/// Callback method.
typedef SearchAddressCallback = Future<void> Function();

/// Callback method.
typedef GetGeometryCallback = Future<Address> Function(Address address);

/// Callback method.
typedef AddressBuilderCallback = Widget Function(
  BuildContext context,
  AsyncSnapshot<List<Address>> snapshot,
  TextEditingController controller,
  SearchAddressCallback searchAddress,
  GetGeometryCallback getGeometry,
);

/// Custom [StatefulBuilder] to create a [Widget] like [AddressSearchDialog].
class AddressSearchBuilder extends StatefulWidget {
  /// Constructor for [AddressSearchBuilder].
  const AddressSearchBuilder({
    required this.geoMethods,
    required this.controller,
    required this.builder,
  })  : assert(builder != null),
        this._addressId = null,
        this._addrComm = null;

  /// Constructor for [AddressSearchBuilder] to show an [AddressSearchDialog].
  factory AddressSearchBuilder.deft({
    required GeoMethods geoMethods,
    required TextEditingController controller,
    required AddressDialogBuilder builder,
    required OnDoneCallback onDone,
  }) {
    return AddressSearchBuilder._(
      geoMethods,
      controller,
      (BuildContext context,
          AsyncSnapshot<List<Address>> snapshot,
          TextEditingController controller,
          Future<void> Function() searchAddress,
          Future<Address> Function(Address address) getGeometry) {
        return _AddressSearchDialog._fromBuilder(
          snapshot,
          controller,
          searchAddress,
          getGeometry,
          builder.color,
          builder.backgroundColor,
          builder.hintText,
          builder.noResultsText,
          builder.cancelText,
          builder.continueText,
          builder.useButtons,
          onDone,
          null,
          null,
        );
      },
      null,
      null,
    );
  }

  /// Constructor for [AddressSearchBuilder] to be called by [RouteSearchBox].
  const AddressSearchBuilder._fromBox(
    this.geoMethods,
    this.controller,
    this._addressId,
    this._addrComm,
  ) : this.builder = null;

  /// Constructor for [AddressSearchBuilder] to be called by [builder].
  const AddressSearchBuilder._(
    this.geoMethods,
    this.controller,
    this.builder,
    this._addressId,
    this._addrComm,
  );

  /// [GeoMethods] instance to use Google APIs.
  final GeoMethods geoMethods;

  /// controller for text used to search an [Address].
  final TextEditingController controller;

  /// Called to obtain the child widget.
  final AddressBuilderCallback? builder;

  /// Identifies the [Address] to work in the [Widget] built.
  final AddressId? _addressId;

  /// Permits to work with the found [Address] by a [RouteSearchBox].
  final _AddrComm? _addrComm;

  /// Builder for a custom [Widget].
  Widget build(AddressBuilderCallback builder) {
    assert(this.builder == null,
        'this method just can be called when this widget is a child of [RouteSearchBox]');
    return AddressSearchBuilder._(
      this.geoMethods,
      this.controller,
      builder,
      this._addressId,
      this._addrComm,
    );
  }

  /// Builder for an [AddressSearchDialog].
  Widget buildDefault({
    required AddressDialogBuilder builder,
    required OnDoneCallback onDone,
  }) {
    assert(this.builder == null,
        'this method just can be called when this widget is a child of [RouteSearchBox]');
    return AddressSearchBuilder._(
      this.geoMethods,
      this.controller,
      // ignore: unnecessary_cast
      (BuildContext context,
          AsyncSnapshot<List<Address>> snapshot,
          TextEditingController controller,
          Future<void> Function() searchAddress,
          Future<Address> Function(Address address) getGeometry) {
        // ignore: unnecessary_cast
        return _AddressSearchDialog._fromBuilder(
          snapshot,
          controller,
          searchAddress,
          getGeometry,
          builder.color,
          builder.backgroundColor,
          builder.hintText,
          builder.noResultsText,
          builder.cancelText,
          builder.continueText,
          builder.useButtons,
          onDone,
          this._addrComm,
          this._addressId,
        ) as Widget;
      } as AddressBuilderCallback?,
      this._addressId,
      this._addrComm,
    );
  }

  @override
  _AddressSearchBuilderState createState() => _AddressSearchBuilderState();
}

class _AddressSearchBuilderState extends State<AddressSearchBuilder> {
  /// Representation of the most recent interaction with [_searchAddress].
  AsyncSnapshot<List<Address>> _snapshot =
      AsyncSnapshot<List<Address>>.nothing();

  @override
  Widget build(BuildContext context) => widget.builder!(
        context,
        _snapshot,
        widget.controller,
        _searchAddress,
        _getGeometry,
      );

  /// Loads a list of found addresses by the text in [widget.controller].
  Future<void> _searchAddress() async {
    if (mounted)
      setState(() => _snapshot = AsyncSnapshot<List<Address>>.waiting());
    final List<Address>? data = await widget.geoMethods
        .autocompletePlace(query: widget.controller.text);
    if (mounted)
      setState(() => _snapshot = (data == null)
          ? AsyncSnapshot<List<Address>>.withError(
              ConnectionState.done, NullThrownError())
          : AsyncSnapshot<List<Address>>.withData(ConnectionState.done, data));
  }

  /// Tries to get a completed [Address] object by a reference or place id.
  Future<Address> _getGeometry(Address address) async {
    final Address? addr = await widget.geoMethods.getPlaceGeometry(
      reference: address.reference,
      placeId: address.placeId!,
    );
    if (widget._addrComm == null || widget._addressId == null)
      return addr ?? address;
    widget._addrComm!.writeAddr(widget._addressId!, addr ?? address);
    return addr ?? address;
  }
}
