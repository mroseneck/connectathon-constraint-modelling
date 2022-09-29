# Constraint modeling proof of concept
Exploration of schema-driven constraint modeling in the context of an SDR.

## Rationale
Currently, the standard for modeling study defnitions is ODM XML.
ODM itself is a standard that gives an ontology of entities (Forms, Events, Items and so on) and their relationships. 
Any concrete ODM Metadata file ("Study Definition") is an "implementation" of that standard, but by itself is nothing more than a further narrowing of the constraints of ODM. E.g. where the ODM standard expects a "SubjectData" Element to have a "StudyEventData" child and a "FormData" child below that, a study definition explicates, what exactly the allowed children are and in which order they appear. The original purpose of these files was to be submitted as metadata alongside the actual data. In the context of ongoing efforts to create sophisticated distributes data flows, it may seem natural to consider a study definition to be something like a shared contract between an SDR and an EDC system.

The major drawback of a Study Definition in this context is that is can not be used as a means to validate the data that was produced by the syste. If it were an actual XML Schema ("Study Schema"), this would be trivial. It would enable anybody to give a Study Schema to an EDC vedor and validate that the clinical data produced by the system is valid agains that scheme.

This would have the following advantages:

1. It would allow to utilize the enormous expressibility of XML Schema, that goes far beyond what can be expressed by ODM XML.
2. Due to its composable nature, it would allow for a modular way to combine and layer constraints, where e.g. structural concerns are clearly separated from other concerns. In ODM the only way of modularizing different constraints is MDV mechanism, which is clearly not intended for this.
3. It would allow anybody to utilize the existing tooling for XML Schema to validate data, generate test data and so on.

## Simple example of the expressive power of XSD
This example shows a typical complex use case in real-world trials. An inclusion item group has three items, that are to be conditionally and successively enabled, i.e.:

1. If the "gender" item has the value "m", then no other items must be present.
2. If the "gender" item has the value "f", then the item "pregnant" must be present and have a value.
3. If the "pregnant" item has the value "n", then the item "month" must not be present.
4. If the "pregnant" item has the value "y", then the item "month" must be present and have a value between 0 and 11.

This entire logic is nicely covered in just two lines of simple XPATH in lines 22 and 23.
This is a way to guarantee adherence to complex conditional constraints.

Besides that the xsd showcases some of the typical features of ODM files, e.g.:

1. structural constraints
2. range checks
3. controlled terminology
4. conditional validity based on values
5. internationalized labels for human readers (line 11)
6. annotations for other computer systems (lines 13 14)

## Running
An XSD 1.1 processor is required to run this schema. E.g. Saxon or Xerces.