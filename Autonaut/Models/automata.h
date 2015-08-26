
typedef struct {
    unsigned char rule;
    unsigned char *data;

    unsigned int width;
    unsigned int height;

} elementaryAutomata;

elementaryAutomata makeElementaryAutomata(unsigned int width, unsigned int height, unsigned char rule, unsigned char *primaryRow);
// primary row should be array size equal to "width"

void gifData(elementaryAutomata eca);

void deleteElementaryAutomata(elementaryAutomata eca);