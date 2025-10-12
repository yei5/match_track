// lib/widgets/perfil_content.dart
import 'package:flutter/material.dart';

class PerfilContent extends StatelessWidget {
  const PerfilContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información personal
          _buildSeccion(
            titulo: 'Información personal',
            contenido: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alexander Rueda',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Añade una descripción',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // Editar perfil
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Equipos que sigues
          _buildSeccion(
            titulo: 'Equipos que sigues',
            contenido: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  height: 240, // Altura aproximada para 3 filas
                  child: GridView.count(
                    crossAxisCount: 3, // 3 columnas
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3 / 1.2,
                    children: [
                      _buildEquipoItem('Equipo A'),
                      _buildEquipoItem('Equipo B'),
                      _buildEquipoItem('Equipo C'),
                      _buildEquipoItem('Equipo D'),
                      _buildEquipoItem('Equipo E'),
                      _buildEquipoItem('Equipo F'),
                      _buildEquipoItem('Equipo G'),
                      _buildEquipoItem('Equipo H'),
                      _buildEquipoItem('Equipo J'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Torneos que sigues
          _buildSeccion(
            titulo: 'Torneos que sigues',
            contenido: Column(
              children: [
                _buildTorneoItem(
                  fecha: '30 sept.',
                  estado: 'Activo',
                  descripcion:
                      'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día lleno de deporte y diversión.',
                ),
                const SizedBox(height: 16),
                _buildTorneoItem(
                  fecha: '30 sept.',
                  estado: 'Activo',
                  descripcion:
                      'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Cerrar sesión
          _buildSeccion(
            contenido: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                _mostrarDialogoCerrarSesion(context);
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSeccion({String? titulo, required Widget contenido}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo != null) ...[
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: contenido,
        ),
      ],
    );
  }

  Widget _buildEquipoItem(String nombreEquipo) {
    return Container(
      alignment: Alignment.center, // Centra el contenido dentro del contenedor
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centra horizontalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sports_soccer, color: Colors.blue, size: 16),
          const SizedBox(width: 6),
          Text(
            nombreEquipo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTorneoItem({
    required String fecha,
    required String estado,
    required String descripcion,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fecha,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getColorEstado(estado),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  estado,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            descripcion,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'finalizado':
        return Colors.grey;
      case 'próximo':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí iría la lógica para cerrar sesión
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
