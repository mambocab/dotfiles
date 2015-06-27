freshccm () {
  ccm stop &>/dev/null
  ccm switch fresh &>/dev/null && ccm remove
  ccm create so-fresh-and-so-clean -n 1 -v git:trunk
  ccm start --wait-for-binary-proto
}
