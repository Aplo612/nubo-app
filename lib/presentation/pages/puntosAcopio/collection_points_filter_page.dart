import 'package:flutter/material.dart';
import '../../../features/collection_points/domain/collection_point.dart';

class CollectionPointsFilterPage extends StatefulWidget {
  const CollectionPointsFilterPage({super.key, this.initialFilter});
  final CollectionPointFilter? initialFilter;

  @override
  State<CollectionPointsFilterPage> createState() => _CollectionPointsFilterPageState();
}

class _CollectionPointsFilterPageState extends State<CollectionPointsFilterPage> {
  final _formKey = GlobalKey<FormState>();
  late CollectionPointFilter _filter;

  final _orgCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  MissionState? _state;
  RewardType? _rewardType;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? const CollectionPointFilter();
    _orgCtrl.text = _filter.organization ?? '';
    _districtCtrl.text = _filter.district ?? '';
    _state = _filter.state;
    _rewardType = _filter.rewardType;
  }

  @override
  void dispose() {
    _orgCtrl.dispose();
    _districtCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    if (_formKey.currentState?.validate() ?? false) {
       //TODO - buscar alternativa en gorouter
      Navigator.of(context).pop(
        _filter.copyWith(
          organization: _orgCtrl.text.trim().isEmpty ? null : _orgCtrl.text.trim(),
          district: _districtCtrl.text.trim().isEmpty ? null : _districtCtrl.text.trim(),
          state: _state,
          rewardType: _rewardType,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de acopio')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text('Filtro', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _orgCtrl,
                  decoration: const InputDecoration(labelText: 'Organización'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<MissionState>(
                  initialValue: _state,
                  decoration: const InputDecoration(labelText: 'Estado de la misión'),
                  items: const [
                    DropdownMenuItem(value: MissionState.activo, child: Text('Activo')),
                    DropdownMenuItem(value: MissionState.inactivo, child: Text('Libre')),
                  ],
                  onChanged: (v) => setState(() => _state = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RewardType>(
                  initialValue: _rewardType,
                  decoration: const InputDecoration(labelText: 'Tipo de recompensa'),
                  items: const [
                    DropdownMenuItem(value: RewardType.libre, child: Text('Libre')),
                    DropdownMenuItem(value: RewardType.puntos, child: Text('Puntos')),
                    DropdownMenuItem(value: RewardType.descuento, child: Text('Descuento')),
                  ],
                  onChanged: (v) => setState(() => _rewardType = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _districtCtrl,
                  decoration: const InputDecoration(labelText: 'Distrito'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _apply,
                    child: const Text('Filtrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
