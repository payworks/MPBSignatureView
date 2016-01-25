from subprocess import call
import os


call(['l10n', 'link', '1CpTflFxUO92TTuhiUz9RkiEwXo5DGnYRlul3Wnfdc3E'])
call(['l10n', 'export', '--exporter=ios'])

call(['cp', 'Localizable-en_US.strings', '../Resources/en.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-de_DE.strings', '../Resources/de.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-fr_FR.strings', '../Resources/fr.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-it_IT.strings', '../Resources/it.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-es_ES.strings', '../Resources/es.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-nl_BE.strings', '../Resources/nl.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-fi_FI.strings', '../Resources/fi.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-pt_PT.strings', '../Resources/pt.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-pl_PL.strings', '../Resources/pl.lproj/MPBSignatureView.strings'])
