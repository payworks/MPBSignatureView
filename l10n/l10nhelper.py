from subprocess import call
import os


call(['l10n', 'link', '1CpTflFxUO92TTuhiUz9RkiEwXo5DGnYRlul3Wnfdc3E'])
call(['l10n', 'export', '--exporter=ios'])

call(['cp', 'Localizable-en_US.strings', '../Resources/en.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-de_DE.strings', '../Resources/de.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-fr_FR.strings', '../Resources/fr.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-it_IT.strings', '../Resources/it.lproj/MPBSignatureView.strings'])
call(['cp', 'Localizable-nl_BE.strings', '../Resources/nl.lproj/MPBSignatureView.strings'])
