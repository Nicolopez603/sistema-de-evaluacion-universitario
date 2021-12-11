//Identify our license
// SPDX-License-Identifier: MIT
//Specify the version
pragma solidity >= 0.4.4 <0.8.11;
pragma experimental ABIEncoderV2;

contract notas{

    //Direccion del profesor
    address public profesor;

    //Constructor
    constructor() public {
        profesor = msg.sender;
    }

    //Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping(bytes32 => uint) Notas;


    //Array de los alumnos que pidan revision del examen
    string [] revisiones;

    //Eventos
    event alumno_evaluado(bytes32, uint);
    event evento_revision(string);

    //Funcion para evaluar a los alumnos
    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender){
       
        //Hash de la id del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        
        //Relacion entre el hash de la identificacion del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        
        //Emitimos un evento
        emit alumno_evaluado(hash_idAlumno, _nota);

    }

    //Control de las funciones ejecutables por el profesor
    modifier UnicamenteProfesor(address _direccion){
        //Require que la direccion introducida por parametro sea igual al owner del contrato
        require(_direccion == profesor, "No tenes permisos para ejecutar esta funcion");
        _;

    }

    //Funcion para ver las notas de un alumno de clase
    function visualizarNotas(string memory _idAlumno) public view returns(uint) {
    //Hash de la id del alumno
    bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
    
    //Nota asociada al hash del alumno
    uint nota_alumno = Notas[hash_idAlumno];

    //Visualizar la nota
    return nota_alumno;


    }


    //Funcion para pedir una revision del examen

    function revision(string memory _idAlumno) public{

        //Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);

        //Emision del evento (revision)
        emit evento_revision(_idAlumno);

    }


    //Funcion para ver los alumnos que han solicitado revision de examen
    function verRevisiones() public view UnicamenteProfesor(msg.sender) returns(string[] memory){
        //Devolver las identidades de los alumnos
        return revisiones;
    }



}